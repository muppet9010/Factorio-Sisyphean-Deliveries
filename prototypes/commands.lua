sisyphean.commands = {
	register = function()
		commands.remove_command("sisyphean_target_set")
		commands.add_command("sisyphean_target_set", {"api-description.sisyphean_target_set"}, function(command_details) sisyphean.commands.target_set(command_details) end)
		commands.remove_command("sisyphean_target_change")
		commands.add_command("sisyphean_target_change", {"api-description.sisyphean_target_change"}, function(command_details) sisyphean.commands.target_change(command_details) end)
		commands.remove_command("sisyphean_regenerate_demand")
		commands.add_command("sisyphean_regenerate_demand", {"api-description.sisyphean_regenerate_demand"}, function(command_details) sisyphean.commands.regenerate_order() end)
		commands.remove_command("sisyphean_start")
		commands.add_command("sisyphean_start", {"api-description.sisyphean_start"}, function(command_details) sisyphean.commands.start() end)
		commands.remove_command("sisyphean_complete_tribute")
		commands.add_command("sisyphean_complete_tribute", {"api-description.sisyphean_complete_tribute"}, function(command_details) sisyphean.commands.complete_order() end)
		commands.remove_command("sisyphean_debug_get_global")
		commands.add_command("sisyphean_debug_get_global", {"api-description.sisyphean_debug_get_global"}, function(command_details) sisyphean.commands.debug_get_global() end)
	end,
	
	target_change = function(command_details)
		local value = command_details.parameter
		if tonumber(value) == nil then
			utillogging_log_print("sisyphean_target_change requires a whole number (integer), value supplied: " .. tostring(value))
			return
		end
		game.print({"api.order_target_changed", tonumber(value), global.state.get_order_target() + tonumber(value), global.state.get_order_target()})
		global.state.set_order_target(global.state.get_order_target() + tonumber(value))
	end,
	
	target_set = function(command_details)
		local value = command_details.parameter
		if tonumber(value) == nil then
			utillogging_log_print("sisyphean_target_set requires a whole number (integer), value supplied: " .. tostring(value))
			return
		end
		game.print({"api.order_target_set", tonumber(value), global.state.get_order_target()})
		global.state.set_order_target(tonumber(value))
	end,
	
	regenerate_order = function()
		local current_order_id = global.state.current_order_id
		if current_order_id > 0 then
			game.print({"api.order_regenerate", current_order_id})
			sisyphean.orders.remove_order(current_order_id)
			sisyphean.orders.generate_order(current_order_id)
		else
			game.print({"api.no_order_to_regenerate"})
		end
	end,
	
	start = function()
		game.print({"api.start"})
		sisyphean.orders.start_orders()
	end,
	
	complete_order =  function()
		local current_order_id = global.state.current_order_id
		if current_order_id > 0 then
			game.print({"api.order_complete", current_order_id})
			local order = global.orders[current_order_id]
			for _, order_item in pairs(order.items) do
				order_item.delivered = order_item.required_quantity
				order_item.completed = true
			end
			sisyphean.orders.calculate_order_item_global_completed_count()
			sisyphean.orders.complete_order(global.orders[current_order_id])
		else
			game.print({"api.no_order_to_complete"})
		end
	end,
	
	debug_get_global = function()
		game.print({"api.get_global"})
		utillogging_log(utillogging_table_contents_to_string(global, "global"))
	end
}