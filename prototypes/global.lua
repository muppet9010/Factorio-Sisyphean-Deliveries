sisyphean.global = {
	--NO CIRCULAR LOOPS AS MAKES DEBUG LOGGING HARDER, STORE ID OF EVERYTHING. MEANS CAN CORRECT GLOBAL STATE VIA SCRIPT IF NEEDED
	generate_global = function()
		--CHANGES TO THIS STRUCTURE MUST BE DONE IN THE CONTROL MIGRATION FUNCTION
		if global == nil then global = {} end
		if global.state == nil then global.state = {} end
		if global.orders == nil then global.orders = {} end
		sisyphean.global.upgrade_pre_global()
		
		if global.state._order_target == nil then
			global.state._order_target = tonumber(settings.startup[sisyphean.setting_name.order_target].value)
		end
		global.state.get_order_target = function()
			return global.state._order_target
		end
		global.state.set_order_target = function(value, skip_gui_update)
			global.state._order_target = value
			sisyphean.orders.calculate_order_item_global_target_count()
			if skip_gui_update == nil or not skip_gui_update then
				sisyphean.gui.update_orders()
			end
		end
		
		if global.state._started == nil then 
			global.state._started = false
		end
		global.state.get_started = function()
			return global.state._started
		end
		global.state.set_started = function()
			global.state._started = true
			global.state._finished = false
			global.state._won = false
			global.state._lost = false
		end
		
		if global.state._finished == nil then 
			global.state._finished = false
		end
		global.state.get_finished = function()
			return global.state._finished
		end
		
		if global.state._won == nil then
			global.state._won = false
		end
		global.state.get_won = function()
			return global.state._won
		end
		global.state.set_won = function()
			global.state._won = true
			global.state._finished = true
			global.state._started = true
			global.state._lost = false
		end
		
		if global.state._lost == nil then
			global.state._lost = false
		end
		global.state.get_lost = function()
			return global.state._lost
		end
		global.state.set_lost = function()
			global.state._lost = true
			global.state._finished = true
			global.state._started = true
			global.state._won = false
		end
		
		if global.state._orders_completed == nil then
			global.state._orders_completed = 0
		end
		global.state.get_orders_completed = function()
			return global.state._orders_completed
		end
		global.state.set_orders_completed = function(value, skip_gui_update)
			global.state._orders_completed = value
			if skip_gui_update == nil or not skip_gui_update then
				sisyphean.gui.update_orders()
			end
		end
		
		if global.state.current_order_id == nil then
			global.state.current_order_id = 0
		end
		
		if global.state.item_target == nil then
			sisyphean.orders.calculate_order_item_global_target_count()
		end
		if global.state.items_completed == nil then
			sisyphean.orders.calculate_order_item_global_completed_count()
		end
		
		if global.state.first_order_countdown_minutes == nil then
			global.state.first_order_countdown_minutes = 0
		end
		if global.state.first_order_countdown_remaining_seconds == nil then
			global.state.first_order_countdown_remaining_seconds = 0
		end
		if global.state.order_countdown_minutes == nil then
			global.state.order_countdown_minutes = 0
		end
		if global.state.order_countdown_warning_minutes == nil then
			global.state.order_countdown_warning_minutes = 0
		end
		
		if global.state.current_demand_receiver_id == nil then global.state.current_demand_receiver_id = 0 end
		if global.demand_receivers == nil then global.demand_receivers = {} end
		if global.state.current_demand_receiver_id == nil then global.state.current_demand_receiver_id = 0 end
		if global.rocket_silo_controllers == nil then global.rocket_silo_controllers = {} end
		if global.state.current_rocket_silo_controller_id == nil then global.state.current_rocket_silo_controller_id = 0 end
		if global.rocket_load_receivers == nil then global.rocket_load_receivers = {} end
		if global.state.current_rocket_load_receiver_id == nil then global.state.current_rocket_load_receiver_id = 0 end
		if global.rocket_silos == nil then global.rocket_silos = {} end
		if global.state.current_rocket_silo_id == nil then global.state.current_rocket_silo_id = 0 end
		
		sisyphean.global.upgrade_post_global()
	end,

	upgrade_pre_global = function()
		sisyphean.global.upgrade_pre_global_0_0_2()
		sisyphean.global.upgrade_pre_global_0_0_3()
		sisyphean.global.upgrade_pre_global_0_0_7()
		sisyphean.global.upgrade_pre_global_0_1_0()
	end,
	
	upgrade_post_global = function()
		sisyphean.global.upgrade_post_global_0_0_3()
	end,

	upgrade_pre_global_0_0_2 = function()
		if global.state.order_target ~= nil then
			global.state._order_target = global.state.order_target
			global.state.order_target = nil
		end
		if global.state.orders_completed ~= nil then
			global.state._orders_completed = global.state.orders_completed
			global.state.orders_completed = nil
		end
	end,

	upgrade_pre_global_0_0_3 = function()
		if global.state.first_order_countdown_remaining_minutes ~= nil and global.state.first_order_countdown_remaining_seconds == nil then
			if global.state.first_order_countdown_remaining_minutes > 0 then
				global.state.first_order_countdown_remaining_seconds = global.state.first_order_countdown_remaining_minutes * 60
			else
				global.state.first_order_countdown_remaining_seconds = 0
			end
			global.state.first_order_countdown_remaining_minutes = nil
		end
	end,
	upgrade_post_global_0_0_3 = function()
		for order_id, order in pairs(global.orders) do
			if order.remaining_minutes ~= nil and order.remaining_seconds == nil then
				if order.remaining_minutes > 0 then
					order.remaining_seconds = order.remaining_minutes * 60
				else
					order.remaining_seconds = 0
				end
				order.remaining_minutes = nil
			end
			if not order.completed then
				sisyphean.orders.update_order_countdown(order)
			else
				sisyphean.orders.complete_order_countdown(order)
			end
		end
	end,

	upgrade_pre_global_0_0_7 = function()
		if global.state.started ~= nil then
			global.state._started = global.state.started
			global.state.started = nil
		end
		if global.state.finished ~= nil then
			global.state._finished = global.state.finished
			global.state.finished = nil
		end
	end,
	
	upgrade_pre_global_0_1_0 = function()
		if global.rocket_silos == nil then global.rocket_silos = {} end
		if global.state.current_rocket_silo_id == nil then global.state.current_rocket_silo_id = 0 end
		local silo_entities = game.surfaces[1].find_entities_filtered{ name="rocket-silo" }
		for i=1, #silo_entities do
			local entity_found = false
			local silo_entity = silo_entities[i]
			for rocket_silo_id, rocket_silo in pairs(global.rocket_silos) do
				if rocket_silo.rocket_silo_entity == silo_entity then
					entity_found = true
					break
				end
			end
			if not entity_found then
				sisyphean.rocket_silo.onbuilt_rocket_silo_entity(silo_entity)
			end
		end
	end
}