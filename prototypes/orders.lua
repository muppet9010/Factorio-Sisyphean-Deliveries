--[[
	CHANGES TO THIS STRUCTURE MUST BE DONE IN THE CONTROL MIGRATION FUNCTION
	global.orders = {
		KEY = sorted order unique number, changes when sorted
		VALUE =	{
			group_id = the group this order belongs to, Int
			order_id = sequential id of order, Int
			completed = true/false, Boolean
			generated_tick = tick the order was generated, Int
			completed_tick = tick the order was completed, Int
			duration_seconds = number of seconds since generated, Int
			remaining_seconds = number of seconds before target time, Int
			remaining_warning = nil or color, RGBA (sisyphean.color)
			items = {
				KEY = sequential id (item_id), Int
				VALUE = {
					item_id = sequential id of item in order, Int
					item_name = item prototype name
					required_quantity = item stack size, Int
					delivered = quantity delivered, Int
					completed = all of item delivered, Boolean
					reserved_by_load_receiver_id = id of the silo load receiver that has reserved the item, Int
				}
			}
		}
	}
]]--

require("prototypes.order_item")

sisyphean.orders = {
	rocket_launched_event = function(rocket_entity, silo_entity)
		if global.state.get_finished() then
			return
		elseif global.state.get_started() then 
			sisyphean.orders.record_rocket(rocket_entity, silo_entity)
		else
			sisyphean.orders.start_orders()
		end
	end,

	start_orders = function()
		global.state.set_started()
		sisyphean.orders.add_new_order()
		sisyphean.gui.add_orders_frame_for_all_players()
	end,

	add_new_order = function()
		if global.state.current_order_id == 0 or global.orders[global.state.current_order_id].completed
		then
			if global.state.get_order_target() == 0 or global.state.get_orders_completed() < global.state.get_order_target() then
				global.state.current_order_id = global.state.current_order_id + 1
				sisyphean.orders.generate_order(global.state.current_order_id)
			else
				global.state.set_won()
			end
		end
	end,

	generate_order = function(this_order_id)
		if global.orders[this_order_id] ~= nil then
			utillogging_log_print("Error - can't generate order id '" .. tostring(this_order_id) .. "' as it already exists")
		end
		
		local possible_items = sisyphean.order_item.get_possible_items()
		local new_order = {
			group_id = 1,
			order_id = this_order_id,
			completed = false, 
			generated_tick = game.tick,
			completed_tick = nil,
			duration_seconds = 0,
			remaining_seconds = 0,
			remaining_warning = nil,
			items = {}
		}
		local demand_item_size = sisyphean.orders.calculate_quantity_of_item_stacks(global.state.current_order_id)
		for i=1, demand_item_size do
			local item_name
			repeat
				item_name = sisyphean.orders.select_random_item(possible_items)
			until (i > #possible_items) or (not sisyphean.orders.order_contains_item(new_order, item_name))
			new_order.items[i] = {
				item_id = i,
				item_name = item_name,
				required_quantity = tonumber(game.item_prototypes[item_name].stack_size),
				delivered = 0,
				completed = false,
				reserved_by_load_receiver_id = nil
			}
		end
		table.sort(new_order.items, sisyphean.orders.compare_order_items)
		global.orders[this_order_id] = new_order
		ontick_update_order_countdown()
		sisyphean.orders.calculate_order_item_global_target_count()
		sisyphean.gui.update_orders()
		sisyphean.demand_receiver.update_all_tribute_receiver_signals()
	end,
	
	order_contains_item = function(order, item_name)
		if settings.global[sisyphean.setting_name.prevent_duplicate_items].value then
			for _, order_item in pairs(order.items) do
				if order_item.item_name == item_name then
					return true
				end
			end
		end
		return false
	end,

	calculate_quantity_of_item_stacks = function(order_count)
		if(tonumber(settings.global[sisyphean.setting_name.order_growth_rate].value) == 0) then
			return tonumber(settings.global[sisyphean.setting_name.order_maximum_size].value)
		end
		local current_cycle = math.max(
			math.floor(
				((order_count - 1) + tonumber(settings.global[sisyphean.setting_name.order_growth_rate].value))
				/ tonumber(settings.global[sisyphean.setting_name.order_growth_rate].value)
			)
		, 1)
		local order_size = current_cycle * tonumber(settings.global[sisyphean.setting_name.order_growth_size].value)
		if order_size > tonumber(settings.global[sisyphean.setting_name.order_maximum_size].value) then
			return tonumber(settings.global[sisyphean.setting_name.order_maximum_size].value)
		else
			return order_size
		end
	end,

	select_random_item = function(possible_items, looped)
		local item_name = possible_items[math.random(#possible_items)]
		if game.item_prototypes[item_name] then
			return item_name
		else
			utillogging_log_print("Error - the item name '" .. item_name .. "' can't be found")
			if not looped then
				return sisyphean.orders.select_random_item(possible_items, true)
			else
				return nil
			end
		end
	end,

	remove_order = function(order_id)
		for _, item in pairs(global.orders[order_id].items) do
			sisyphean.rocket_load_receiver.handle_item_completed(item.reserved_by_load_receiver_id, item.item_id)
		end
		global.orders[order_id] = nil
	end,
	
	record_rocket = function(rocket_entity, silo_entity)
		local order_id = global.state.current_order_id 
		local order = global.orders[order_id]
		local rocket_inventory = rocket_entity.get_inventory(defines.inventory.rocket).get_contents()
		
		local rocket_silo = sisyphean.rocket_silo.find_rocket_silo_for_entity(silo_entity)
		local rocket_load_receiver_id = nil
		if rocket_silo ~= nil then
			rocket_load_receiver_id = rocket_silo.rocket_load_receiver_id
		end
		sisyphean.orders.record_rocket_inventory_to_order_and_return_remainder_inventory(rocket_inventory, rocket_load_receiver_id, order, "reserved only")
		sisyphean.orders.record_rocket_inventory_to_order_and_return_remainder_inventory(rocket_inventory, rocket_load_receiver_id, order, "not reserved")
		sisyphean.orders.record_rocket_inventory_to_order_and_return_remainder_inventory(rocket_inventory, rocket_load_receiver_id, order, "any")
		sisyphean.rocket_load_receiver.handle_current_item_completed(rocket_load_receiver_id)
				
		table.sort(order.items, sisyphean.orders.compare_order_items)
		local order_incomplete = false
		for _, order_item in pairs(order.items) do
			if not order_item.completed then
				order_incomplete = true
				break
			end
		end
		sisyphean.orders.calculate_order_item_global_completed_count()
		if not order_incomplete then
			sisyphean.orders.complete_order(order)
		else
			sisyphean.gui.update_orders()
		end
		sisyphean.demand_receiver.update_all_tribute_receiver_signals()
	end,
	
	record_rocket_inventory_to_order_and_return_remainder_inventory = function(rocket_inventory, rocket_load_receiver_id, order, mode)
		for inventory_name, inventory_quantity in pairs(rocket_inventory) do
			for _, order_item in pairs(order.items) do
				if 
					(mode == "reserved only" and order_item.reserved_by_load_receiver_id ~= nil and order_item.reserved_by_load_receiver_id == rocket_load_receiver_id) or
					(mode == "not reserved" and order_item.reserved_by_load_receiver_id == nil) or
					(mode == "any")
				then
					if order_item.item_name == inventory_name and not order_item.completed then
						order_item.delivered = order_item.delivered + inventory_quantity
						if mode == "reserved only" then
							order_item.reserved_by_load_receiver_id = nil
						end
						if order_item.delivered >= order_item.required_quantity then
							order_item.completed = true
							order_item.reserved_by_load_receiver_id = nil
							sisyphean.rocket_load_receiver.handle_item_completed(rocket_load_receiver_id, order_item.item_id)
						end
						if order_item.delivered > order_item.required_quantity then
							rocket_inventory[inventory_name] = order_item.delivered - order_item.required_quantity
							inventory_quantity = rocket_inventory[inventory_name]
							order_item.delivered = order_item.required_quantity
						else
							rocket_inventory[inventory_name] = 0
							break;
						end
					end
				end
			end
		end
	end,
	
	compare_order_items = function(a, b)
		if not a.completed and b.completed then
			return true
		elseif a.completed and not b.completed then
			return false
		elseif a.completed and b.completed then
			if a.item_name < b.item_name then
				return true
			else
				return false
			end
		else
			if a.delivered > 0 and b.delivered == 0 then
				return true
			elseif a.delivered == 0 and b.delivered > 0 then
				return false
			else
			if a.item_name < b.item_name then
					return true
				else
					return false
				end
			end
		end
		return false
	end,
	
	complete_order = function(order)
		order.completed = true
		order.completed_tick = game.tick
		sisyphean.orders.complete_order_countdown(order)
		global.state.set_orders_completed(global.state.current_order_id, false)
		if global.state.get_order_target() > 0 and global.state.get_orders_completed() == global.state.get_order_target() then
			global.state.set_won()
			sisyphean.gui.show_win_message_for_all_players()
		else
			sisyphean.orders.add_new_order()
		end
		for _, item in pairs(order.items) do
			item.completed = true
			sisyphean.rocket_load_receiver.handle_item_completed(item.reserved_by_load_receiver_id, item.item_id)
		end
		sisyphean.gui.update_orders()
		sisyphean.demand_receiver.update_all_tribute_receiver_signals()
	end,
	
	update_all_order_countdowns = function()
		for order_id, order in pairs(global.orders) do
			if not order.completed then
				sisyphean.orders.update_order_countdown(order)
			end
		end
	end,
	
	update_order_countdown = function(order)
		order.duration_seconds = math.floor((game.tick - order.generated_tick) / 60)
		order.remaining_seconds = (global.state.order_countdown_minutes * 60) - order.duration_seconds
		local old_remaining_warning = order.remaining_warning
		if order.remaining_seconds <= math.floor((global.state.order_countdown_warning_minutes * 60) / 2) then
			order.remaining_warning = sisyphean.color.red
		elseif order.remaining_seconds <= (global.state.order_countdown_warning_minutes * 60) then
			order.remaining_warning = sisyphean.color.brightorange
		else
			order.remaining_warning = nil
		end
		if (old_remaining_warning == nil and order.remaining_warning ~= nil) or (old_remaining_warning == sisyphean.color.brightorange and order.remaining_warning == sisyphean.color.red) then
			sisyphean.gui.add_orders_frame_for_all_players()
		end
		if not global.state.get_finished() and order.remaining_seconds <= 0 then
			global.state.set_lost()
			sisyphean.gui.add_orders_frame_for_all_players()
			sisyphean.gui.show_failure_message_for_all_players()
		end
	end,
	
	complete_order_countdown = function(order)
		order.duration_seconds = math.floor((order.completed_tick - order.generated_tick) / 60)
		order.remaining_seconds = 0
		order.remaining_warning = nil
	end,
	
	calculate_order_item_global_completed_count = function()
		global.state.items_completed = 0
		if #global.orders > 0 then
			for order_id, order in pairs(global.orders) do
				if order.completed then
					global.state.items_completed = global.state.items_completed + #order.items
				else
					for _, order_item in pairs(order.items) do
						if order_item.completed then
							global.state.items_completed = global.state.items_completed + 1
						end
					end
				end
			end
		end
	end,
	
	calculate_order_item_global_target_count = function()
		global.state.item_target = 0
		if global.state.get_order_target() > 0 then
			for order_id, order in pairs(global.orders) do
				for _, order_item in pairs(order.items) do
					global.state.item_target = global.state.item_target + 1
				end
			end
			local i = global.state.current_order_id + 1
			while i < global.state.get_order_target() do
				global.state.item_target = global.state.item_target + sisyphean.orders.calculate_quantity_of_item_stacks(i)
				i = i + 1
			end
		end
	end,
	
	are_orders_active = function()
		if not global.state.get_started() or global.state.get_won() or global.state.get_lost() or global.orders[global.state.current_order_id].completed then 
			return false
		else
			return true
		end
	end,
	
	get_current_tribute_orders_outstanding = function()
		local outstanding_items = {}
		if not sisyphean.orders.are_orders_active() then return outstanding_items end
		for _, item in pairs(global.orders[global.state.current_order_id].items) do
			if not item.completed then
				table.insert(outstanding_items, {name = item.item_name, quantity = item.required_quantity - item.delivered})
			end
		end
		return outstanding_items
	end,
	
	reserve_a_current_tribute_item = function(rocket_load_receiver_id)
		if not sisyphean.orders.are_orders_active() then return nil end
		for _, item in pairs(global.orders[global.state.current_order_id].items) do
			if not item.completed and item.reserved_by_load_receiver_id == nil then
				item.reserved_by_load_receiver_id = rocket_load_receiver_id
				return item.item_id
			end
		end
		return nil
	end,
	
	handle_rocket_load_receiver_remove_reserve = function(order_id, item_id)
		local item = sisyphean.orders.get_order_item(order_id, item_id)
		if item ~= nil then
			item.reserved_by_load_receiver_id = nil
		end
	end,
	
	get_order_item = function(order_id, item_id)
		if global.orders[order_id] ~= nil then
			for _, item in pairs(global.orders[order_id].items) do
				if item.item_id == item_id then
					return item
				end
			end
		end
		return nil
	end,
	
	check_current_order_all_items_rocket_load_receivers_still_exist = function()
		if not sisyphean.orders.are_orders_active() then return end
		for _, item in pairs(global.orders[global.state.current_order_id].items) do
			if not item.completed and item.reserved_by_load_receiver_id ~= nil then
				if global.rocket_load_receivers[item.reserved_by_load_receiver_id] == nil then
					item.reserved_by_load_receiver_id = nil
				elseif global.rocket_load_receivers[item.reserved_by_load_receiver_id].rocket_silo_id == nil then
					sisyphean.rocket_load_receiver.handle_item_completed(item.reserved_by_load_receiver_id, item.item_id)
					item.reserved_by_load_receiver_id = nil
				end
			end
		end
	end
}