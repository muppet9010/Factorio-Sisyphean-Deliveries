sisyphean.order_item = {
	initialise = function() 
		sisyphean.order_item.make_item_lists()
	end,

	make_item_lists = function()
		sisyphean.order_item.make_factory_item_list()
		sisyphean.order_item.make_manual_item_list()
		sisyphean.order_item.make_raw_ingredients_item_list()
		sisyphean.order_item.make_barrelled_item_list()
		sisyphean.order_item.make_flooring_item_list()
		sisyphean.order_item.make_uranium_products_item_list()
		sisyphean.order_item.make_vehicle_turret_ammo_item_list()
		sisyphean.order_item.make_circuitry_item_list()
		sisyphean.order_item.make_equipment_item_list()
		sisyphean.order_item.make_massive_item_list()
		sisyphean.order_item.make_science_item_list()
	end,

	get_possible_items = function()
		local possible_items = {}
		if settings.global[sisyphean.order_item_type.factory].value then luahelper_merge_tables(possible_items, sisyphean.order_item.factory_item_list) end
		if settings.global[sisyphean.order_item_type.manual].value then luahelper_merge_tables(possible_items, sisyphean.order_item.manual_item_list) end
		if settings.global[sisyphean.order_item_type.raw_ingredients].value then luahelper_merge_tables(possible_items, sisyphean.order_item.raw_ingredients_item_list) end
		if settings.global[sisyphean.order_item_type.barrelled].value then luahelper_merge_tables(possible_items, sisyphean.order_item.barrelled_item_list) end
		if settings.global[sisyphean.order_item_type.flooring].value then luahelper_merge_tables(possible_items, sisyphean.order_item.flooring_item_list) end
		if settings.global[sisyphean.order_item_type.uranium_products].value then luahelper_merge_tables(possible_items, sisyphean.order_item.uranium_products_item_list) end
		if settings.global[sisyphean.order_item_type.vehicle_turret_ammo].value then luahelper_merge_tables(possible_items, sisyphean.order_item.vehicle_turret_ammo_item_list) end
		if settings.global[sisyphean.order_item_type.equipment].value then luahelper_merge_tables(possible_items, sisyphean.order_item.equipment_item_list) end
		if settings.global[sisyphean.order_item_type.circuitry].value then luahelper_merge_tables(possible_items, sisyphean.order_item.circuitry_item_list) end
		if settings.global[sisyphean.order_item_type.massive].value then luahelper_merge_tables(possible_items, sisyphean.order_item.massive_item_list) end
		if settings.global[sisyphean.order_item_type.science].value then luahelper_merge_tables(possible_items, sisyphean.order_item.science_item_list) end
		return possible_items
	end,

	

	make_manual_item_list = function()
		sisyphean.order_item.manual_item_list = {
			"raw-fish",
			"wooden-chest",
			"raw-wood",
			"wood",
			"small-electric-pole"
		}
	end,
	
	make_massive_item_list = function()
		sisyphean.order_item.massive_item_list = {
			"rocket-silo"
		}
	end,
	
	make_equipment_item_list = function()
		sisyphean.order_item.equipment_item_list = {
			"battery-equipment",
			"battery-mk2-equipment",
			"discharge-defense-equipment",
			"energy-shield-equipment",
			"energy-shield-mk2-equipment",
			"exoskeleton-equipment",
			"fusion-reactor-equipment",
			"night-vision-equipment",
			"personal-laser-defense-equipment",
			"personal-roboport-equipment",
			"personal-roboport-mk2-equipment",
			"solar-panel-equipment",
			"heavy-armor",
			"light-armor",
			"modular-armor",
			"power-armor",
			"power-armor-mk2",
			"artillery-targeting-remote",
			"cluster-grenade",
			"defender-capsule",
			"destroyer-capsule",
			"discharge-defense-remote",
			"distractor-capsule",
			"grenade",
			"poison-capsule",
			"slowdown-capsule",
			"combat-shotgun",
			"flamethrower",
			"pistol",
			"rocket-launcher",
			"shotgun",
			"submachine-gun",
			"land-mine",
			"iron-axe",
			"steel-axe",
			"repair-pack"
		}
	end,
	
	make_raw_ingredients_item_list = function() 
		sisyphean.order_item.raw_ingredients_item_list = {
			"coal",
			"copper-ore",
			"iron-ore",
			"stone",
			"uranium-ore"
		}
	end,

	make_barrelled_item_list = function()
		sisyphean.order_item.barrelled_item_list = {
			"crude-oil-barrel",
			"light-oil-barrel",
			"lubricant-barrel",
			"petroleum-gas-barrel",
			"sulfuric-acid-barrel",
			"water-barrel",
			"heavy-oil-barrel"
		}
	end,
	
	make_flooring_item_list = function()
		sisyphean.order_item.flooring_item_list = {
			"hazard-concrete",
			"refined-concrete",
			"refined-hazard-concrete",
			"concrete"
		}
	end,
	
	make_uranium_products_item_list = function()
		sisyphean.order_item.uranium_products_item_list = {
			"uranium-235",
			"uranium-238",
			"uranium-fuel-cell",
			"atomic-bomb",
			"explosive-uranium-cannon-shell",
			"uranium-cannon-shell",
			"uranium-rounds-magazine",
			"nuclear-fuel"
		}
	end,
	
	make_vehicle_turret_ammo_item_list = function()
		sisyphean.order_item.vehicle_turret_ammo_item_list = {
			"artillery-turret",
			"artillery-wagon",
			"car",
			"cargo-wagon",
			"flamethrower-turret",
			"fluid-wagon",
			"gun-turret",
			"locomotive",
			"tank",
			"laser-turret",
			"artillery-shell",
			"cannon-shell",
			"explosive-cannon-shell",
			"explosive-rocket",
			"firearm-magazine",
			"flamethrower-ammo",
			"piercing-rounds-magazine",
			"piercing-shotgun-shell",
			"rocket",
			"shotgun-shell"
		}
	end,
	
	make_circuitry_item_list = function()
		sisyphean.order_item.circuitry_item_list = {
			"arithmetic-combinator",
			"constant-combinator",
			"decider-combinator",
			"power-switch",
			"programmable-speaker"
		}
	end,
	
	make_science_item_list = function()
		sisyphean.order_item.science_item_list = {
			"science-pack-1",
			"science-pack-2",
			"science-pack-3",
			"military-science-pack",
			"production-science-pack",
			"high-tech-science-pack",
			"space-science-pack"
		}
	end,
	
	make_factory_item_list = function()
		sisyphean.order_item.factory_item_list = {
			"accumulator",
			"advanced-circuit",
			"assembling-machine-1",
			"assembling-machine-2",
			"assembling-machine-3",
			"battery",
			"beacon",
			"big-electric-pole",
			"boiler",
			"burner-inserter",
			"burner-mining-drill",
			"centrifuge",
			"chemical-plant",
			"construction-robot",
			"copper-cable",
			"copper-plate",
			"cliff-explosives",
			"electric-engine-unit",
			"electric-furnace",
			"electric-mining-drill",
			"electronic-circuit",
			"empty-barrel",
			"engine-unit",
			"explosives",
			"express-splitter",
			"express-transport-belt",
			"express-underground-belt",
			"fast-inserter",
			"fast-splitter",
			"fast-transport-belt",
			"fast-underground-belt",
			"filter-inserter",
			"flying-robot-frame",
			"gate",
			"green-wire",
			"heat-exchanger",
			"heat-pipe",
			"inserter",
			"iron-chest",
			"iron-gear-wheel",
			"iron-plate",
			"iron-stick",
			"lab",
			"landfill",
			"logistic-chest-active-provider",
			"logistic-chest-buffer",
			"logistic-chest-passive-provider",
			"logistic-chest-requester",
			"logistic-chest-storage",
			"logistic-robot",
			"long-handed-inserter",
			"medium-electric-pole",
			"nuclear-reactor",
			"offshore-pump",
			"oil-refinery",
			"pipe",
			"pipe-to-ground",
			"plastic-bar",
			"processing-unit",
			"pump",
			"pumpjack",
			"radar",
			"rail",
			"rail-chain-signal",
			"rail-signal",
			"red-wire",
			"roboport",
			"small-lamp",
			"solar-panel",
			"solid-fuel",
			"splitter",
			"stack-filter-inserter",
			"stack-inserter",
			"steam-engine",
			"steam-turbine",
			"steel-chest",
			"steel-furnace",
			"steel-plate",
			"stone-brick",
			"stone-furnace",
			"stone-wall",
			"storage-tank",
			"substation",
			"sulfur",
			"train-stop",
			"transport-belt",
			"underground-belt",
			"effectivity-module",
			"effectivity-module-2",
			"effectivity-module-3",
			"productivity-module",
			"productivity-module-2",
			"productivity-module-3",
			"speed-module",
			"speed-module-2",
			"speed-module-3"
		}
	end
}