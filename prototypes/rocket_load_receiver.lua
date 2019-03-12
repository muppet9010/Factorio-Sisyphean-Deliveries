--[[
	CHANGES TO THIS STRUCTURE MUST BE DONE IN THE CONTROL MIGRATION FUNCTION
	global.rocket_load_receivers = {
		KEY = sequential id (rocket_load_receiver_id), Int
		VALUE =	{
			rocket_load_receiver_id = sequential id of rocket load receiver, Int
			rocket_load_receiver_entity = ENTITY (this)
			rocket_silo_id = global.rocket_silos object id or nil
			reserved_order_id = id of the order that the reserved item belongs to
			reserved_item_id = id of the item of the reserved item
		}
	}
--]]
sisyphean.rocket_load_receiver = {
	onbuilt_rocket_load_receiver_entity = function(rocket_load_receiver_entity)
		global.state.current_rocket_load_receiver_id = global.state.current_rocket_load_receiver_id + 1
		global.rocket_load_receivers[global.state.current_rocket_load_receiver_id] = {
			rocket_load_receiver_id = global.state.current_rocket_load_receiver_id,
			rocket_load_receiver_entity = rocket_load_receiver_entity,
			rocket_silo_id = nil,
			reserved_order_id = nil,
			reserved_item_id = nil
		}
		
		local neighbour_rocket_silos = sisyphean.rocket_silo.find_neighbouring_rocket_silos(rocket_load_receiver_entity)
		local neighbour_rocket_silo_id = nil
		for i=1, #neighbour_rocket_silos do
			for silo_id, silo in pairs (global.rocket_silos) do
				if silo.rocket_silo_entity == neighbour_rocket_silos[i] and silo.rocket_load_receiver == nil then
					neighbour_rocket_silo_id = silo.rocket_silo_id
					break
				end
			end
			if neighbour_rocket_silo_id ~= nil then break; end
		end
		if neighbour_rocket_silo_id ~= nil then
			global.rocket_load_receivers[global.state.current_rocket_load_receiver_id].rocket_silo_id = neighbour_rocket_silo_id
			sisyphean.rocket_silo.record_rocket_load_receiver_for_rocket_silo(global.state.current_rocket_load_receiver_id, neighbour_rocket_silo_id)
		end
	end,
	
	onremoved_rocket_load_receiver_entity = function(rocket_load_receiver_entity)
		for rocket_load_receiver_id, rocket_load_receiver in pairs(global.rocket_load_receivers) do
			if rocket_load_receiver.rocket_load_receiver_entity == rocket_load_receiver_entity then
				sisyphean.rocket_load_receiver.remove_rocket_load_receiver(rocket_load_receiver)
				break
			end
		end
	end,
	
	remove_rocket_load_receiver = function(rocket_load_receiver)
		sisyphean.rocket_silo.remove_linked_rocket_load_receiver(rocket_load_receiver.rocket_silo_id)
		sisyphean.rocket_load_receiver.release_order_item(rocket_load_receiver)
		global.rocket_load_receivers[rocket_load_receiver.rocket_load_receiver_id] = nil
	end,

	record_rocket_silo_for_rocket_load_receiver = function(rocket_silo_id, rocket_load_receiver_id)
		global.rocket_load_receivers[rocket_load_receiver_id].rocket_silo_id = rocket_silo_id
	end,
	
	remove_linked_rocket_silo = function(rocket_load_receiver_id)
		local rocket_load_receiver = global.rocket_load_receivers[rocket_load_receiver_id]
		if rocket_load_receiver == nil then return end
		rocket_load_receiver.rocket_silo_id = nil
		sisyphean.rocket_load_receiver.release_order_item(rocket_load_receiver)
	end,
	
	update_all_rocket_load_receivers = function()
		for rocket_load_receiver_id, rocket_load_receiver in pairs(global.rocket_load_receivers) do
			sisyphean.rocket_load_receiver.update_rocket_load_receiver(rocket_load_receiver)
		end
	end,

	update_rocket_load_receiver = function(receiver)
		if receiver.rocket_load_receiver_entity == nil or not receiver.rocket_load_receiver_entity.valid then
			sisyphean.rocket_load_receiver.remove_rocket_load_receiver(receiver)
			return
		end
		receiver.rocket_load_receiver_entity.get_control_behavior().parameters = sisyphean.rocket_load_receiver.calculate_rocket_load_receiver_signals(receiver)
	end,
	
	release_order_item = function(receiver)
		sisyphean.orders.handle_rocket_load_receiver_remove_reserve(receiver.reserved_order_id, receiver.reserved_item_id)
		receiver.reserved_order_id = nil
		receiver.reserved_item_id = nil
	end,
	
	calculate_rocket_load_receiver_signals = function(receiver)
		local signalParameters = { parameters = {} }
		if receiver.rocket_silo_id == nil then return signalParameters end
		local rocket_inventory = global.rocket_silos[receiver.rocket_silo_id].rocket_silo_entity.get_inventory(defines.inventory.rocket_silo_rocket)
		if rocket_inventory == nil then 
			table.insert(
				signalParameters.parameters,
				{
					index = 1,
					signal = {
						type = "virtual",
						name = "signal-sisypheandeliveries-rocketpreparing"
					},
					count = 1
				}
			)
			return signalParameters
		end
		local rocket_contents = rocket_inventory.get_contents()

		--If there is a reserved order and item, validate it hasn't been manually done
		if receiver.reserved_order_id ~= nil and receiver.reserved_item_id ~= nil then
			local reserved_item = sisyphean.orders.get_order_item(receiver.reserved_order_id, receiver.reserved_item_id)
			if receiver.reserved_order_id ~= global.state.current_order_id or reserved_item == nil or reserved_item.completed then
				sisyphean.rocket_load_receiver.release_order_item(receiver)
			end
		end
		
		--Check if currently reserved item is fully loaded
		local outstanding_item = sisyphean.rocket_load_receiver.get_outstanding_current_reserved_item_details(receiver, rocket_contents)
		if outstanding_item ~= nil and outstanding_item.quantity == 0 then
			receiver.reserved_order_id = nil
			receiver.reserved_item_id = nil
			outstanding_item = nil
		end
		
		--Reserve an item if one isn't already and there's room.
		if outstanding_item == nil and rocket_inventory.can_insert({name = "iron-plate", count = 1}) then
			receiver.reserved_item_id = sisyphean.orders.reserve_a_current_tribute_item(receiver.rocket_load_receiver_id)
			if receiver.reserved_item_id == nil then
				receiver.reserved_order_id = nil
			else 
				receiver.reserved_order_id = global.state.current_order_id
				outstanding_item = sisyphean.rocket_load_receiver.get_outstanding_current_reserved_item_details(receiver, rocket_contents)
			end
		end
		
		--if there is loaded items and none outstanding then launch
		local rocket_ready_launch = nil
		if outstanding_item == nil and not rocket_inventory.is_empty() then
			rocket_ready_launch = true
		else
			rocket_ready_launch = false
		end
		
		if rocket_ready_launch then
			table.insert(
				signalParameters.parameters,
				{
					index = 1,
					signal = {
						type = "virtual",
						name = "signal-sisypheandeliveries-rocketreadylaunch"
					},
					count = 1
				}
			)
		else
			table.insert(
				signalParameters.parameters,
				{
					index = 1,
					signal = {
						type = "virtual",
						name = "signal-sisypheandeliveries-rocketreadyload"
					},
					count = 1
				}
			)
			if outstanding_item ~= nil then
				table.insert(
					signalParameters.parameters,
					{
						index = 2,
						signal = {
							type = "item",
							name = outstanding_item.name
						},
						count = outstanding_item.quantity
					}
				)
				table.insert(
					signalParameters.parameters,
					{
						index = 3,
						signal = {
							type = "virtual",
							name = "signal-sisypheandeliveries-demandstacksize"
						},
						count = outstanding_item.quantity
					}
				)
			end
		end
		return signalParameters
	end,
	
	handle_item_completed = function(load_receiver_id, item_id)
		local receiver = global.rocket_load_receivers[load_receiver_id]
		if receiver ~= nil and receiver.reserved_item_id ~= nil and receiver.reserved_item_id == item_id then
			receiver.reserved_order_id = nil
			receiver.reserved_item_id = nil
		end
	end,
	
	handle_current_item_completed = function(load_receiver_id)
		local receiver = global.rocket_load_receivers[load_receiver_id]
		if receiver ~= nil then
			receiver.reserved_order_id = nil
			receiver.reserved_item_id = nil
		end
	end,
	
	get_outstanding_current_reserved_item_details = function(receiver, rocket_contents)
		if receiver.reserved_order_id == nil or receiver.reserved_item_id == nil then return nil end
		local reserved_item = sisyphean.orders.get_order_item(receiver.reserved_order_id, receiver.reserved_item_id)
		if reserved_item == nil then return nil end
		local rocket_contents_quantity = 0
		if rocket_contents[reserved_item.item_name] ~= nil then
			rocket_contents_quantity = rocket_contents[reserved_item.item_name]
		end
		local outstanding_item = {
			name = reserved_item.item_name,
			quantity = reserved_item.required_quantity - (reserved_item.delivered + rocket_contents_quantity)
		}
		return outstanding_item
	end,
	
	check_globals_still_exist = function()
		for rocket_load_receiver_id, rocket_load_receiver in pairs(global.rocket_load_receivers) do
			if rocket_load_receiver.rocket_load_receiver_entity ~= nil and not rocket_load_receiver.rocket_load_receiver_entity.valid then
				sisyphean.rocket_load_receiver.remove_rocket_load_receiver(rocket_load_receiver)
			end
		end
	end
}