--[[
	CHANGES TO THIS STRUCTURE MUST BE DONE IN A MIGRATION SCRIPT
	global.demand_receivers = {
		KEY = sequential id (demand_receiver_id), Int
		VALUE =	{
			demand_receiver_id = sequential id of demand receiver, Int
			demand_receiver_entity = in game entity link
		}
	}
--]]

sisyphean.demand_receiver = {
	onbuilt_tribute_demand_receiver_entity = function(demand_receiver_entity)
		global.state.current_demand_receiver_id = global.state.current_demand_receiver_id + 1
		global.demand_receivers[global.state.current_demand_receiver_id] = {
			demand_receiver_id = global.state.current_demand_receiver_id,
			demand_receiver_entity = demand_receiver_entity
		}
		sisyphean.demand_receiver.update_receiver_signals(demand_receiver_entity)
	end,
	
	onremoved_tribute_demand_receiver_entity = function(demand_receiver_entity)
		for demand_receiver_id, demand_receiver in pairs(global.demand_receivers) do
			if demand_receiver.demand_receiver_entity == demand_receiver_entity then
				sisyphean.demand_receiver.remove_tribute_demand_receiver(demand_receiver)
				return
			end
		end
	end,
	
	remove_tribute_demand_receiver = function(demand_receiver)
		global.demand_receivers[demand_receiver.demand_receiver_id] = nil
	end,
	
	update_all_tribute_receiver_signals = function()
		local signalParameters = sisyphean.demand_receiver.get_tribute_outstanding_signal()
		for demand_receiver_id, demand_receiver in pairs(global.demand_receivers) do
			sisyphean.demand_receiver.update_receiver_signals(demand_receiver.demand_receiver_entity, signalParameters)
		end
	end,
	
	update_receiver_signals = function(demand_receiver_entity, signalParameters)
		if signalParameters == nil then signalParameters = sisyphean.demand_receiver.get_tribute_outstanding_signal() end
        demand_receiver_entity.get_control_behavior().parameters = signalParameters
	end,
	
	get_tribute_outstanding_signal = function()
		local signalParameters = { parameters = {} }
		local outstanding_items = sisyphean.orders.get_current_tribute_orders_outstanding()
		for i=1, #outstanding_items do
			table.insert(
				signalParameters.parameters,
				{
					index = i,
					signal = {
						type = "item",
						name = outstanding_items[i].name
					},
					count = outstanding_items[i].quantity
				}
			)
		end
		signalParameters = sisyphean.demand_receiver.add_target_time_remaining_signal(signalParameters)
		return signalParameters
	end,
	
	add_target_time_remaining_signal = function(signalParameters)
		if global.state.first_order_countdown_remaining_seconds > 0 then
			table.insert(
				signalParameters.parameters,
				{
					index = #signalParameters.parameters + 1,
					signal = {
						type = "virtual",
						name = "signal-sisypheandeliveries-timeremaining"
					},
					count = global.state.first_order_countdown_remaining_seconds
				}
			)
		elseif global.state.order_countdown_minutes > 0 then
			table.insert(
				signalParameters.parameters,
				{
					index = #signalParameters.parameters + 1,
					signal = {
						type = "virtual",
						name = "signal-sisypheandeliveries-timeremaining"
					},
					count = global.orders[global.state.current_order_id].remaining_seconds
				}
			)
		end
		return signalParameters
	end,
	
	check_globals_still_exist = function()
		for demand_receiver_id, demand_receiver in pairs(global.demand_receivers) do
			if demand_receiver.demand_receiver_entity ~= nil and not demand_receiver.demand_receiver_entity.valid then
				sisyphean.demand_receiver.remove_demand_receiver(demand_receiver)
			end
		end
	end
}