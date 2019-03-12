--[[
	CHANGES TO THIS STRUCTURE MUST BE DONE IN THE CONTROL MIGRATION FUNCTION
	global.rocket_silo_controllers = {
		KEY = sequential id (rocket_silo_controller_id), Int
		VALUE =	{
			rocket_silo_controller_id = sequential id of rocket silo controller, Int
			rocket_silo_controller_entity = ENTITY (this)
			rocket_silo_id = global.rocket_silos object id or nil
		}
	}
--]]
sisyphean.rocket_silo_controller = {
	onbuilt_rocket_silo_controller_entity = function(rocket_silo_controller_entity)
		global.state.current_rocket_silo_controller_id = global.state.current_rocket_silo_controller_id + 1
		global.rocket_silo_controllers[global.state.current_rocket_silo_controller_id] = {
			rocket_silo_controller_id = global.state.current_rocket_silo_controller_id,
			rocket_silo_controller_entity = rocket_silo_controller_entity,
			rocket_silo_id = nil
		}
		
		local neighbour_rocket_silos = sisyphean.rocket_silo.find_neighbouring_rocket_silos(rocket_silo_controller_entity)
		local neighbour_rocket_silo_id = nil
		for i=1, #neighbour_rocket_silos do
			for silo_id, silo in pairs (global.rocket_silos) do
				if silo.rocket_silo_entity == neighbour_rocket_silos[i] and silo.rocket_silo_controller == nil then
					neighbour_rocket_silo_id = silo.rocket_silo_id
					break
				end
			end
			if neighbour_rocket_silo_id ~= nil then break; end
		end
		if neighbour_rocket_silo_id ~= nil then
			global.rocket_silo_controllers[global.state.current_rocket_silo_controller_id].rocket_silo_id = neighbour_rocket_silo_id
			sisyphean.rocket_silo.record_rocket_silo_controller_for_rocket_silo(global.state.current_rocket_silo_controller_id, neighbour_rocket_silo_id)
		end
	end,
	
	onremoved_rocket_silo_controller_entity = function(rocket_silo_controller_entity)
		for rocket_silo_controller_id, rocket_silo_controller in pairs(global.rocket_silo_controllers) do
			if rocket_silo_controller.rocket_silo_controller_entity == rocket_silo_controller_entity then
				sisyphean.rocket_silo_controller.remove_rocket_silo_controller(rocket_silo_controller)
				break
			end
		end
	end,
	
	remove_rocket_silo_controller = function(rocket_silo_controller)
		sisyphean.rocket_silo.remove_linked_rocket_silo_controller(rocket_silo_controller.rocket_silo_id)
		global.rocket_silo_controllers[rocket_silo_controller.rocket_silo_controller_id] = nil
	end,

	record_rocket_silo_for_rocket_silo_controller = function(rocket_silo_id, rocket_silo_controller_id)
		global.rocket_silo_controllers[rocket_silo_controller_id].rocket_silo_id = rocket_silo_id
	end,
	
	remove_linked_rocket_silo = function(rocket_silo_controller_id)
		global.rocket_silo_controllers[rocket_silo_controller_id].rocket_silo_id = nil
	end,
	
	update_all_rocket_silo_controllers = function()
		for rocket_silo_controller_id, rocket_silo_controller in pairs(global.rocket_silo_controllers) do
			sisyphean.rocket_silo_controller.update_rocket_silo_controller(rocket_silo_controller)
		end
	end,
	
	update_rocket_silo_controller = function(controller)
		if controller.rocket_silo_id == nil then return end
		if controller.rocket_silo_controller_entity == nil or not controller.rocket_silo_controller_entity.valid then
			sisyphean.rocket_silo_controller.remove_rocket_silo_controller(controller)
			return
		end
		local control_behavior = controller.rocket_silo_controller_entity.get_control_behavior()
		if control_behavior == nil then return end
		if control_behavior.circuit_condition.fulfilled or control_behavior.logistic_condition.fulfilled then
			global.rocket_silos[controller.rocket_silo_id].rocket_silo_entity.launch_rocket()
		end
	end,
	
	check_globals_still_exist = function()
		for rocket_silo_controller_id, rocket_silo_controller in pairs(global.rocket_silo_controllers) do
			if rocket_silo_controller.rocket_silo_controller_entity ~= nil and not rocket_silo_controller.rocket_silo_controller_entity.valid then
				sisyphean.rocket_silo_controller.remove_rocket_silo_controller(rocket_silo_controller)
			end
		end
	end
}