--[[
	CHANGES TO THIS STRUCTURE MUST BE DONE IN A MIGRATION SCRIPT
	global.rocket_silos = {
		KEY = sequential id (rocket_silo_id), Int
		VALUE =	{
			rocket_silo_id = sequential id of rocket silo, Int
			rocket_silo_entity = in game entity link
			rocket_silo_controller_id = global.rocket_silo_controllers object id or nil
			rocket_load_receiver_id = global.rocket_load_receivers object id or nil
		}
	}
--]]

sisyphean.rocket_silo = {
	onbuilt_rocket_silo_entity = function(silo_entity)
		global.state.current_rocket_silo_id = global.state.current_rocket_silo_id + 1
		global.rocket_silos[global.state.current_rocket_silo_id] = {
			rocket_silo_id = global.state.current_rocket_silo_id,
			rocket_silo_entity = silo_entity,
			rocket_silo_controller_id = nil,
			rocket_load_receiver_id = nil
		}
		
		local neighbour_rocket_silo_controllers = sisyphean.rocket_silo.find_neighbouring_named_entities(silo_entity, "rocket-silo-controller")
		local neighbour_rocket_silo_controller_id = nil
		for i=1, #neighbour_rocket_silo_controllers do
			for controller_id, controller in pairs (global.rocket_silo_controllers) do
				if controller.controller_entity == neighbour_rocket_silo_controllers[i] and controller.rocket_silo == nil then
					neighbour_rocket_silo_controller_id = controller.rocket_silo_controller_id
					break
				end
			end
			if neighbour_rocket_silo_controller_id ~= nil then break; end
		end
		if neighbour_rocket_silo_controller_id ~= nil then
			global.rocket_silos[global.state.current_rocket_silo_id].rocket_silo_controller_id = neighbour_rocket_silo_controller_id
			sisyphean.rocket_silo_controller.record_rocket_silo_for_rocket_silo_controller(global.state.current_rocket_silo_id, neighbour_rocket_silo_controller_id)
		end
		
		local neighbour_rocket_load_receivers = sisyphean.rocket_silo.find_neighbouring_named_entities(silo_entity, "rocket-load-receiver")
		local neighbour_rocket_load_receiver_id = nil
		for i=1, #neighbour_rocket_load_receivers do
			for receiver_id, receiver in pairs (global.rocket_load_receivers) do
				if receiver.receiver_entity == neighbour_rocket_load_receivers[i] and receiver.rocket_silo == nil then
					neighbour_rocket_load_receiver_id = receiver.rocket_load_receiver_id
					break
				end
			end
			if neighbour_rocket_load_receiver_id ~= nil then break; end
		end
		if neighbour_rocket_load_receiver_id ~= nil then
			global.rocket_silos[global.state.current_rocket_silo_id].rocket_load_receiver_id = neighbour_rocket_load_receiver_id
			sisyphean.rocket_load_receiver.record_rocket_silo_for_rocket_load_receiver(global.state.current_rocket_silo_id, neighbour_rocket_load_receiver_id)
		end
	end,
	
	onremoved_rocket_silo_entity = function(silo_entity)
		for rocket_silo_id, rocket_silo in pairs(global.rocket_silos) do
			if rocket_silo.rocket_silo_entity == silo_entity then
				sisyphean.rocket_silo.remove_rocket_silo(rocket_silo)
				break
			end
		end
	end,
	
	remove_rocket_silo = function(rocket_silo)
		if rocket_silo.rocket_silo_controller_id ~= nil then
			sisyphean.rocket_silo_controller.remove_linked_rocket_silo(rocket_silo.rocket_silo_controller_id)
		end
		if rocket_silo.rocket_load_receiver_id ~= nil then
			sisyphean.rocket_load_receiver.remove_linked_rocket_silo(rocket_silo.rocket_load_receiver_id)
		end
		global.rocket_silos[rocket_silo.rocket_silo_id] = nil
	end,

	find_neighbouring_rocket_silos = function(entity)
		area = {
			{entity.position.x - 1, entity.position.y - 1}
			, {entity.position.x + 1, entity.position.y + 1}
		}
		return game.surfaces[1].find_entities_filtered{area=area, name="rocket-silo"}
	end,
		
	find_neighbouring_named_entities = function(silo_entity, target_name)
		area = {
			{silo_entity.position.x - 5, silo_entity.position.y - 5.5}
			, {silo_entity.position.x + 5, silo_entity.position.y + 5.5}
		}
		return game.surfaces[1].find_entities_filtered{area=area, name=target_name}
	end,
	
	record_rocket_silo_controller_for_rocket_silo = function(rocket_silo_controller_id, rocket_silo_id)
		global.rocket_silos[rocket_silo_id].rocket_silo_controller_id = rocket_silo_controller_id
	end,
	
	remove_linked_rocket_silo_controller = function(rocket_silo_id)
		if rocket_silo_id == nil then return end
		global.rocket_silos[rocket_silo_id].rocket_silo_controller_id = nil
	end,
	
	record_rocket_load_receiver_for_rocket_silo = function(rocket_load_receiver_id, rocket_silo_id)
		global.rocket_silos[rocket_silo_id].rocket_load_receiver_id = rocket_load_receiver_id
	end,
	
	remove_linked_rocket_load_receiver = function(rocket_silo_id)
		if rocket_silo_id == nil then return end
		global.rocket_silos[rocket_silo_id].rocket_load_receiver_id = nil
	end,
	
	find_rocket_silo_for_entity = function(silo_entity)
		for rocket_silo_id, rocket_silo in pairs(global.rocket_silos) do
			if rocket_silo.rocket_silo_entity == silo_entity then
				return rocket_silo
			end
		end
		return nil
	end,
	
	check_globals_still_exist = function()
		for rocket_silo_id, rocket_silo in pairs(global.rocket_silos) do
			if rocket_silo.rocket_silo_entity ~= nil and not rocket_silo.rocket_silo_entity.valid then
				sisyphean.rocket_silo.remove_rocket_silo(rocket_silo)
			end
		end
	end
}