require("prototypes.utility.utils")
require("constants")

require("prototypes.global")
require("prototypes.commands")
require("prototypes.orders")
require("prototypes.gui")

require("prototypes.demand_receiver")
require("prototypes.rocket_silo_controller")
require("prototypes.rocket_load_receiver")
require("prototypes.rocket_silo")



local function start_up()
	sisyphean.order_item.initialise()
	sisyphean.commands.register()
	disable_satelite_dialog()
end

local function on_player_created(event)
	local player = game.players[event.player_index]
	sisyphean.gui.add_gui_for_player(player)
end

local function on_player_joined_game(event)
	local player = game.players[event.player_index]
	sisyphean.gui.refresh_orders_frame_for_player(player)
end

local function on_gui_click(event)
	sisyphean.gui.gui_clicked(event)
end

function disable_satelite_dialog()
	if remote.interfaces["silo_script"] then
		local trackedInventory = remote.call("silo_script","get_tracked_items")
		for name in pairs(trackedInventory) do
			remote.call("silo_script", "remove_tracked_item", name)
		end
		remote.call("silo_script","set_no_victory", true)
	end
end

local function onsecond_update()
	ontick_update_first_rocket_countdown()
	ontick_update_order_countdown()
	sisyphean.gui.update_countdowns_for_all_players()
	sisyphean.demand_receiver.update_all_tribute_receiver_signals()
end

local function on10second_update()
	sisyphean.rocket_silo.check_globals_still_exist()
	sisyphean.rocket_silo_controller.check_globals_still_exist()
	sisyphean.rocket_load_receiver.check_globals_still_exist()
	sisyphean.demand_receiver.check_globals_still_exist()
	sisyphean.orders.check_current_order_all_items_rocket_load_receivers_still_exist()
end

function ontick_update_first_rocket_countdown()
	if not global.state.get_started() then
		global.state.first_order_countdown_minutes = tonumber(settings.global[sisyphean.setting_name.order_start_target_minutes].value)
		local target_ticks = global.state.first_order_countdown_minutes * 3600
		if global.state.first_order_countdown_minutes > 0 then
			global.state.first_order_countdown_remaining_seconds = math.floor((target_ticks - game.tick) / 60)
			local old_first_order_countdown_warning = global.state.first_order_countdown_warning
			if global.state.first_order_countdown_remaining_seconds <= math.ceil((global.state.first_order_countdown_minutes * 60) / 10) then
				global.state.first_order_countdown_warning = sisyphean.color.red
			elseif global.state.first_order_countdown_remaining_seconds <= math.ceil((global.state.first_order_countdown_minutes * 60) / 5) then
				global.state.first_order_countdown_warning = sisyphean.color.brightorange
			else
				global.state.first_order_countdown_warning = nil
			end
			if (old_first_order_countdown_warning == nil and global.state.first_order_countdown_warning ~= nil) or (old_first_order_countdown_warning == sisyphean.color.brightorange and global.state.first_order_countdown_warning == sisyphean.color.red) then
				sisyphean.gui.add_orders_frame_for_all_players()
			end
			if not global.state.get_finished() and global.state.first_order_countdown_remaining_seconds <= 0 then
				global.state.set_lost()
				sisyphean.gui.update_orders()
				sisyphean.gui.show_failure_message_for_all_players()
			end
		end
	else
		global.state.first_order_countdown_minutes = 0
		global.state.first_order_countdown_remaining_seconds = 0
		global.state.first_order_countdown_warning = nil
	end
end

function ontick_update_order_countdown()
	if global.state.get_started() then
		global.state.order_countdown_minutes = tonumber(settings.global[sisyphean.setting_name.order_delivery_target_minutes].value)
		if global.state.order_countdown_minutes > 0 then
			global.state.order_countdown_warning_minutes = math.ceil(global.state.order_countdown_minutes / 5)
			sisyphean.orders.update_all_order_countdowns()
		else
			global.state.order_countdown_warning_minutes = 0
		end
	else
		global.state.order_countdown_minutes = 0
		global.state.order_countdown_warning_minutes = 0
	end
end

local function on_built_entity(event)
    local entity = event.created_entity
    if entity.name == "tribute-demand-receiver" then
        sisyphean.demand_receiver.onbuilt_tribute_demand_receiver_entity(entity)
    elseif entity.name == "rocket-silo-controller" then
        sisyphean.rocket_silo_controller.onbuilt_rocket_silo_controller_entity(entity)
	elseif entity.name == "rocket-load-receiver" then
		sisyphean.rocket_load_receiver.onbuilt_rocket_load_receiver_entity(entity)
	elseif entity.name == "rocket-silo" then
		sisyphean.rocket_silo.onbuilt_rocket_silo_entity(entity)
    end
end

local function on_removed_entity(event)
    local entity = event.entity
    if entity.name == "tribute-demand-receiver" then
        sisyphean.demand_receiver.onremoved_tribute_demand_receiver_entity(entity)
    elseif entity.name == "rocket-silo-controller" then
        sisyphean.rocket_silo_controller.onremoved_rocket_silo_controller_entity(entity)
	elseif entity.name == "rocket-load-receiver" then
		sisyphean.rocket_load_receiver.onremoved_rocket_load_receiver_entity(entity)
	elseif entity.name == "rocket-silo" then
		sisyphean.rocket_silo.onremoved_rocket_silo_entity(entity)
    end
end

function onquicktick_update()
	sisyphean.rocket_load_receiver.update_all_rocket_load_receivers()
	sisyphean.rocket_silo_controller.update_all_rocket_silo_controllers()
end



script.on_init(function()
	sisyphean.global.generate_global()
	start_up()
end)
script.on_load(function()
	start_up()
end)
script.on_configuration_changed(function()
	sisyphean.global.generate_global()
	start_up()
	sisyphean.gui.remove_all_gui_versions_for_all_players()
	sisyphean.gui.add_gui_for_all_players()
end)
script.on_nth_tick(10, function() onquicktick_update() end)
script.on_nth_tick(60, function() onsecond_update() end)
script.on_nth_tick(600, function() on10second_update() end)
script.on_event({defines.events.on_player_created}, on_player_created)
script.on_event({defines.events.on_player_joined_game}, on_player_joined_game)
script.on_event({defines.events.on_gui_click}, on_gui_click)
script.on_event(defines.events.on_rocket_launched, function(event)
	sisyphean.orders.rocket_launched_event(event.rocket, event.rocket_silo)
end)
script.on_event(defines.events.on_built_entity, on_built_entity)
script.on_event(defines.events.on_robot_built_entity, on_built_entity)
script.on_event(defines.events.on_player_mined_entity, on_removed_entity)
script.on_event(defines.events.on_entity_died, on_removed_entity)
script.on_event(defines.events.on_robot_mined_entity, on_removed_entity)