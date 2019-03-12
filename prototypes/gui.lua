require("prototypes.styles")

sisyphean.gui = {	
	add_gui_for_player = function(player)
		if player.gui.left.sisyphean_flow then player.gui.left.sisyphean_flow.destroy() end
		player.gui.left.add{type = "flow", name = "sisyphean_flow", direction = "vertical"}
		local sisyphean_flow = player.gui.left.sisyphean_flow
		sisyphean.styles.padding.left_4(sisyphean_flow)
		sisyphean_flow.add{type = "button", name = sisyphean.gui_elem.main_menu_button, caption = {"description.sisyphean-menu-caption"}, tooltip={"description.sisyphean-menu-tooltip"}}
		sisyphean.styles.padding.all_2(sisyphean_flow[sisyphean.gui_elem.main_menu_button])
		if global.state.get_finished() then
			return
		elseif 
			(not global.state.get_started() and global.state.first_order_countdown_minutes > 0)
			or (global.state.get_started() and global.state.order_countdown_minutes > 0)
		then
			sisyphean.gui.add_orders_frame_for_player(player)
		else
			return
		end
	end, 
	
	add_gui_for_all_players = function()
		for _, player in pairs(game.players) do
			sisyphean.gui.add_gui_for_player(player)
		end
	end,
	
	remove_all_gui_versions_for_all_players = function()
		for _, player in pairs(game.players) do
			if player.gui.top[sisyphean.gui_elem.main_menu_button] then player.gui.top[sisyphean.gui_elem.main_menu_button].destroy() end
			if player.gui.left.sisyphean_orders_frame then player.gui.left.sisyphean_orders_frame.destroy() end
			if player.gui.left.sisyphean_flow then player.gui.left.sisyphean_flow.destroy() end
		end
	end,

	update_orders = function()
		sisyphean.gui.refresh_orders_frame_for_all_players()
	end,
	
	gui_clicked = function(event)
		local player = game.players[event.player_index]
		if event.element.name == sisyphean.gui_elem.main_menu_button then
			sisyphean.gui.toggle_orders_frame_for_player(player)
		elseif event.element.name == sisyphean.gui_elem.toggle_completed_orders_button then
			sisyphean.gui.toggle_completed_orders_frame_for_player(player)
		elseif event.element.name == sisyphean.gui_elem.close_finished_frame_button then
			sisyphean.gui.close_finished_message_for_player(player)
		end
	end,
	
	toggle_orders_frame_for_player = function(player)
		if player.gui.left.sisyphean_flow.sisyphean_orders_frame then
			sisyphean.gui.remove_orders_frame_for_player(player)
		else
			sisyphean.gui.add_orders_frame_for_player(player)
		end
	end,
	
	remove_orders_frame_for_player = function(player)
		player.gui.left.sisyphean_flow.sisyphean_orders_frame.destroy()
	end,
	
	add_orders_frame_for_player = function(player)
		local sisyphean_flow = player.gui.left.sisyphean_flow
		if sisyphean_flow.sisyphean_orders_frame then sisyphean_flow.sisyphean_orders_frame.destroy() end
		
		sisyphean_flow.add{type = "frame", name = "sisyphean_orders_frame", direction = "vertical"}
		if global.state.get_finished() then
			if global.state.get_won() then
				sisyphean_flow.sisyphean_orders_frame.add{type = "label", name = "sisyphean_finished_label", caption = {"description.sisyphean-finished-win-caption", global.state.get_orders_completed()}, tooltip = {"description.sisyphean-finished-win-tooltip"}}
				sisyphean.styles.font_color.green(sisyphean_flow.sisyphean_orders_frame.sisyphean_finished_label)
			else
				sisyphean_flow.sisyphean_orders_frame.add{type = "label", name = "sisyphean_finished_label", caption = {"description.sisyphean-finished-failure-caption", global.state.get_orders_completed(), global.state.get_order_target()}, tooltip = {"description.sisyphean-finished-failure-tooltip"}}
				sisyphean.styles.font_color.brightred(sisyphean_flow.sisyphean_orders_frame.sisyphean_finished_label)
			end
		elseif global.state.get_started() then
			if global.state.get_order_target() == 0 then
				sisyphean_flow.sisyphean_orders_frame.add{type = "label", name = "sisyphean_completed_label", caption = {"description.sisyphean-completed-caption", global.state.get_orders_completed()}, tooltip = {"description.sisyphean-completed-tooltip"}}
				sisyphean_flow.sisyphean_orders_frame.add{type = "label", name = "sisyphean_completed_items_label", caption = {"description.sisyphean-completed-item-caption", global.state.items_completed}, tooltip = {"description.sisyphean-completed-item-tooltip"}}
			else
				sisyphean_flow.sisyphean_orders_frame.add{type = "label", name = "sisyphean_completed_label", caption = {"description.sisyphean-completed-with-target-caption", global.state.get_orders_completed(), global.state.get_order_target(), luamath_round(((global.state.get_orders_completed() / global.state.get_order_target()) * 100 ), 1)}, tooltip = {"description.sisyphean-completed-with-target-tooltip"}}
				sisyphean_flow.sisyphean_orders_frame.add{type = "label", name = "sisyphean_completed_items_label", caption = {"description.sisyphean-completed-with-target-item-caption", global.state.items_completed, global.state.item_target, luamath_round(((global.state.items_completed / global.state.item_target) * 100 ), 1)}, tooltip = {"description.sisyphean-completed-with-target-item-tooltip"}}
			end
			
			sisyphean_flow.sisyphean_orders_frame.add{type = "scroll-pane", name = "sisyphean_orders_scroll", horizontal_scroll_policy = "never", vertical_scroll_policy = "auto"}
			sisyphean_flow.sisyphean_orders_frame.sisyphean_orders_scroll.style.maximal_height = 500
			
			for order_id, order in pairs(global.orders) do
				if not order.completed then
					sisyphean.gui.add_order_to_orders_scroll(player, order)
				end
			end
		else
			sisyphean_flow.sisyphean_orders_frame.add{type = "label", name = "sisyphean_not_started_label", caption = {"description.sisyphean-not-started-caption"}, tooltip = {"description.sisyphean-not-started-tooltip"}}
			sisyphean.gui.add_not_started_countdown_label_for_player(player)
		end
		
		--sisyphean_flow.sisyphean_orders_frame.sisyphean_orders_scroll.add{type = "button", name = sisyphean.gui_elem.toggle_completed_orders_button, caption = {"description.sisyphean-orders-show-completed-caption"}, tooltip = {"description.sisyphean-orders-show-completed-tooltip"}}
	end,
	
	add_not_started_countdown_label_for_player = function(player)
		local sisyphean_flow = player.gui.left.sisyphean_flow
		if global.state.first_order_countdown_minutes > 0 then
			local timer_countdown_caption = sisyphean.gui.make_localised_string_display_time_units("description.sisyphean-not-started-countdown-caption", "seconds", global.state.first_order_countdown_remaining_seconds, nil)
			sisyphean_flow.sisyphean_orders_frame.add{type = "label", name = "sisyphean_not_started_countdown_label", caption = timer_countdown_caption, tooltip = {"description.sisyphean-not-started-countdown-tooltip"}}
			if global.state.first_order_countdown_warning ~= nil then
				sisyphean.styles.font_color.set(sisyphean_flow.sisyphean_orders_frame.sisyphean_not_started_countdown_label, global.state.first_order_countdown_warning)
			end
		end
	end,
	
	refresh_not_started_countdown_label_for_player = function(player)
		local sisyphean_flow = player.gui.left.sisyphean_flow
		if sisyphean_flow == nil or sisyphean_flow.sisyphean_orders_frame == nil or sisyphean_flow.sisyphean_orders_frame.sisyphean_not_started_countdown_label == nil then return end
		sisyphean_flow.sisyphean_orders_frame.sisyphean_not_started_countdown_label.destroy()
		sisyphean.gui.add_not_started_countdown_label_for_player(player)
	end,
	
	add_order_to_orders_scroll = function(player, order)
		local order_frame_name = "order_frame_" .. tostring(order.order_id)
		local sisyphean_flow = player.gui.left.sisyphean_flow
		sisyphean_flow.sisyphean_orders_frame.sisyphean_orders_scroll.add{type = "frame", name = order_frame_name, direction = "vertical"}
		local order_frame = sisyphean_flow.sisyphean_orders_frame.sisyphean_orders_scroll[order_frame_name]
		
		local order_fame_label_flow_name = order_frame_name .. "_label_flow"
		order_frame.add{type = "flow", name = order_fame_label_flow_name, direction = "vertical"}
		sisyphean.gui.add_order_frame_label_name_for_player(player, order)
		
		local order_items_container_name = order_frame_name .. "_items_container"
		order_frame.add{type = "table", name = order_items_container_name, column_count = 5}
		local order_items_container = order_frame[order_items_container_name]

		sisyphean.gui.add_items_to_order(order, order_frame_name, order_items_container)
	end,
	
	add_order_frame_label_name_for_player = function(player, order)
		local sisyphean_flow = player.gui.left.sisyphean_flow
		local order_frame_name = "order_frame_" .. tostring(order.order_id)
		local order_fame_label_flow_name = order_frame_name .. "_label_flow"
		local order_frame_label_flow = sisyphean_flow.sisyphean_orders_frame.sisyphean_orders_scroll[order_frame_name][order_fame_label_flow_name]
		local order_frame_label_name = order_frame_name .. "_label"
		if global.state.order_countdown_minutes == 0 then
			order_frame_label_flow.add{type = "label", name = order_frame_label_name, caption = {"description.sisyphean-order-title-caption", order.order_id}}
			if order.completed then
				sisyphean.styles.font_color.green(order_frame_label_flow[order_frame_label_name])
			end
		else
			if not order.completed then
			local timer_countdown_caption = sisyphean.gui.make_localised_string_display_time_units("description.sisyphean-order-title-countdown-time-caption", "seconds", order.remaining_seconds, {order.order_id})
				order_frame_label_flow.add{type = "label", name = order_frame_label_name, caption = timer_countdown_caption}
				if order.remaining_warning ~= nil then
					sisyphean.styles.font_color.set(order_frame_label_flow[order_frame_label_name], order.remaining_warning)
				end
			else
				order_frame_label_flow.add{type = "label", name = order_frame_label_name, caption = {"description.sisyphean-order-title-completed-time-caption", order.order_id, math.floor(order.duration_seconds/60)}}
				sisyphean.styles.font_color.green(order_frame_label_flow[order_frame_label_name])
			end
		end
	end,
	
	refresh_order_frame_label_name_for_player = function(player, order)
		local sisyphean_flow = player.gui.left.sisyphean_flow
		if sisyphean_flow == nil then return end
		local order_frame_name = "order_frame_" .. tostring(order.order_id)
		local order_fame_label_flow_name = order_frame_name .. "_label_flow"
		if sisyphean_flow.sisyphean_orders_frame == nil or sisyphean_flow.sisyphean_orders_frame.sisyphean_orders_scroll == nil or sisyphean_flow.sisyphean_orders_frame.sisyphean_orders_scroll[order_frame_name] == nil then return end
		local order_frame = sisyphean_flow.sisyphean_orders_frame.sisyphean_orders_scroll[order_frame_name]
		local order_frame_label_name = order_frame_name .. "_label"
		if sisyphean_flow.sisyphean_orders_frame.sisyphean_orders_scroll[order_frame_name][order_fame_label_flow_name] == nil then return end
		local order_frame_label_flow = sisyphean_flow.sisyphean_orders_frame.sisyphean_orders_scroll[order_frame_name][order_fame_label_flow_name]
		if order_frame_label_flow[order_frame_label_name] == nil then return end
		order_frame_label_flow[order_frame_label_name].destroy()
		sisyphean.gui.add_order_frame_label_name_for_player(player, order)
	end,
	
	add_items_to_order = function(order, order_frame_name, order_items_container)
		local order_details = global.orders[order.order_id]
		--local sorted_order_items = luahelper_duplicate_deep_table(order_details.items)
		for _, item in pairs(order_details.items) do
			sisyphean.gui.add_item_to_order(item, order_frame_name, order_items_container)
		end
	end,
	
	add_item_to_order = function(item, order_frame_name, order_items_container)
		local item_prototype = game.item_prototypes[item.item_name]
		local item_frame_name = order_frame_name .. "_item_" .. item.item_id .."_frame"
		order_items_container.add{type = "frame", name = item_frame_name, direction = "vertical", tooltip = {"description.sisyphean-order-item-tooltip", item_prototype.localised_name, item.delivered, item.required_quantity}}
		local item_frame = order_items_container[item_frame_name]
		
		local item_frame_sprite_name = item_frame_name .."_sprite"
		item_frame.add{type = "sprite", name = item_frame_sprite_name, tooltip = {"description.sisyphean-order-item-tooltip", item_prototype.localised_name, item.delivered, item.required_quantity}, sprite = "item/" .. item.item_name}
		local item_frame_sprite = item_frame[item_frame_sprite_name]
		
		local item_frame_delivered_count_name = item_frame_name .."_label"
		item_frame.add{type = "label", name = item_frame_delivered_count_name, caption = {"description.sisyphean-order-item-caption", item.delivered}, tooltip = {"description.sisyphean-order-item-tooltip", item.item_name, item.delivered, item.required_quantity}}
		local item_frame_delivered_count = item_frame[item_frame_delivered_count_name]
		if item.completed then
			sisyphean.styles.font_color.green(item_frame_delivered_count)
		end
	end,
	
	add_orders_frame_for_all_players = function()
		for _, player in pairs(game.players) do
			if player.connected then
				sisyphean.gui.add_orders_frame_for_player(player)
			end
		end
	end,
	
	refresh_orders_frame_for_player = function(player)
		if player.gui.left.sisyphean_flow.sisyphean_orders_frame then
			player.gui.left.sisyphean_flow.sisyphean_orders_frame.destroy()
			sisyphean.gui.add_orders_frame_for_player(player)
		end
	end,
	
	refresh_orders_frame_for_all_players = function()
		for _, player in pairs(game.players) do
			if player.connected then
				sisyphean.gui.refresh_orders_frame_for_player(player)
			end
		end
	end,
	
	update_countdowns_for_all_players = function() 
		for _, player in pairs(game.players) do
			if player.connected then
				sisyphean.gui.refresh_countdowns_for_player(player)
			end
		end
	end,
	
	refresh_countdowns_for_player = function(player)
		sisyphean.gui.refresh_not_started_countdown_label_for_player(player)
		for order_id, order in pairs(global.orders) do
			if not order.completed then
				sisyphean.gui.refresh_order_frame_label_name_for_player(player, order)
			end
		end
	end,
	
	toggle_completed_orders_frame_for_player = function(player)
		game.print("TODO - toggle_completed_orders_frame_for_player called for player: " .. player.name)
	end,
	
	seconds_to_display_time_units = function(unit_type, value)
		local result = {}
		result.unit_type = unit_type
		if unit_type == "seconds" then
			result.total_seconds = value
		elseif unit_type == "minutes" then
			result.total_seconds = value * 60
		elseif unit_type == "hours" then
			result.total_seconds = value * 3600
		else
			utillogging_log_print("sisyphean.gui.seconds_to_display_time_units called with invalid unit_type: " .. unit_type)
		end
		result.negative = false
		if result.total_seconds < 0 then
			result.negative = true
			result.total_seconds = 0 - result.total_seconds
		end
		
		local review_seconds = result.total_seconds
		if review_seconds > 3600 then
			result.hours = math.floor(review_seconds / 3600)
			review_seconds = review_seconds % 3600
		else
			result.hours = 0
		end
		if review_seconds > 60 then
			result.minutes = math.floor(review_seconds / 60)
			review_seconds = review_seconds % 60
		else
			result.minutes = 0
		end
		if review_seconds > 0 then
			result.seconds = review_seconds
		else
			result.seconds = 0
		end
		
		return result
	end,
	
	make_localised_string_display_time_units = function(localised_string_base, unit_type, value, initial_localised_arguments)
		time_units_display = sisyphean.gui.seconds_to_display_time_units(unit_type, value)

		local localised_string_object = {}
		table.insert(localised_string_object, localised_string_base)
		if initial_localised_arguments ~= nil and #initial_localised_arguments > 0 then
			for i=1, #initial_localised_arguments do
				table.insert(localised_string_object, initial_localised_arguments[i])
			end
		end
		
		local time_string_name = ""
		local time_units_string = ""
		if time_units_display.hours ~= 0 then
			time_string_name = "description.sisyphean-time-hours"
			time_units_string = time_units_display.hours
			time_units_string = time_units_string .. ":" .. sisyphean.gui.pad_time_to_2_digits(time_units_display.minutes)
		elseif time_units_display.minutes ~= 0 then
			time_string_name = "description.sisyphean-time-minutes"
			time_units_string = time_units_display.minutes
			time_units_string = time_units_string .. ":" .. sisyphean.gui.pad_time_to_2_digits(time_units_display.seconds)
		else
			time_string_name = "description.sisyphean-time-seconds"
			time_units_string = time_units_display.seconds
		end
		if time_units_display.negative then
			time_units_string = "-" .. time_units_string
		end
		table.insert(localised_string_object, {time_string_name, time_units_string})
		
		return localised_string_object
	end,
	
	pad_time_to_2_digits = function(timevalue)
		if timevalue < 10 then
			return "0" .. tostring(timevalue)
		else
			return timevalue
		end
	end,
	
	show_win_message_for_all_players = function()
		for _, player in pairs(game.players) do
			if player.connected then
				sisyphean.gui.show_win_message(player)
			end
		end
	end,
	
	show_win_message = function(player)
		sisyphean.gui.close_finished_message_for_player(player)
		player.gui.center.add{type = "frame", name = "sisyphean_finished_frame", caption = {"description.sisyphean-win-title-caption"}, direction = "vertical"}
		player.gui.center.sisyphean_finished_frame.add{type = "label", name = "sisyphean_win_body_text", caption = {"description.sisyphean-win-message-caption"}}
		sisyphean.styles.item.finished_frame_text(player.gui.center.sisyphean_finished_frame.sisyphean_win_body_text)
		player.gui.center.sisyphean_finished_frame.add{type = "button", name = sisyphean.gui_elem.close_finished_frame_button, caption = {"description.sisyphean-win-close-button-caption"}, tooltip = {"description.sisyphean-win-close-button-tooltip"}}
	end,
	
	show_failure_message_for_all_players = function()
		for _, player in pairs(game.players) do
			if player.connected then
				sisyphean.gui.show_failure_message(player)
			end
		end
	end,
	
	show_failure_message = function(player)
		sisyphean.gui.close_finished_message_for_player(player)
		player.gui.center.add{type = "frame", name = "sisyphean_finished_frame", caption = {"description.sisyphean-failure-title-caption"}, direction = "vertical"}
		player.gui.center.sisyphean_finished_frame.add{type = "label", name = "sisyphean_failure_body_text", caption = {"description.sisyphean-failure-message-caption"}}
		sisyphean.styles.item.finished_frame_text(player.gui.center.sisyphean_finished_frame.sisyphean_failure_body_text)
		player.gui.center.sisyphean_finished_frame.add{type = "button", name = sisyphean.gui_elem.close_finished_frame_button, caption = {"description.sisyphean-failure-close-button-caption"}, tooltip = {"description.sisyphean-failure-close-button-tooltip"}}
	end,
	
	close_finished_message_for_player = function(player)
		if player.gui.center.sisyphean_finished_frame then player.gui.center.sisyphean_finished_frame.destroy() end
	end
}