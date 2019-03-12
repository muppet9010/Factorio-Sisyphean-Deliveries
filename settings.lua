require("constants")

data:extend({
	{
		name = sisyphean.setting_name.order_growth_rate,
		type = "int-setting",
		default_value = 1,
		minimum_value = 0,
		setting_type = "runtime-global",
		order = "1001"
	},
	{
		name = sisyphean.setting_name.order_growth_size,
		type = "string-setting",
		default_value = "1",
		minimum_value = 1,
		setting_type = "runtime-global",
		order = "1002"
	},
	{
		name = sisyphean.setting_name.order_maximum_size,
		type = "int-setting",
		default_value = 10,
		minimum_value = 1,
		maximum_value = 100,
		setting_type = "runtime-global",
		order = "1003"
	},
	{
		name = sisyphean.setting_name.prevent_duplicate_items,
		type = "bool-setting",
		default_value = true,
		setting_type = "runtime-global",
		order = "1004"
	},
	{
		name = sisyphean.setting_name.order_target,
		type = "int-setting",
		default_value = 0,
		minimum_value = 0,
		setting_type = "startup",
		order = "5000"
	},
	{
		name = sisyphean.setting_name.order_delivery_target_minutes,
		type = "int-setting",
		default_value = 0,
		minimum_value = 0,
		setting_type = "runtime-global",
		order = "5001"
	},
	{
		name = sisyphean.setting_name.order_start_target_minutes,
		type = "int-setting",
		default_value = 0,
		minimum_value = 0,
		setting_type = "runtime-global",
		order = "5002"
	},
	{
		name = sisyphean.setting_name.rocket_cargo_size,
		type = "int-setting",
		default_value = 1,
		minimum_value = 1,
		maximum_value = 100,
		setting_type = "startup",
		order = "6000"
	},
	

	
	{
		name = sisyphean.order_item_type.factory,
		type = "bool-setting",
		default_value = "true",
		setting_type = "runtime-global",
		order = "8011"
	},
	{
		name = sisyphean.order_item_type.manual,
		type = "bool-setting",
		default_value = "false",
		setting_type = "runtime-global",
		order = "8000"
	},
	{
		name = sisyphean.order_item_type.raw_ingredients,
		type = "bool-setting",
		default_value = "true",
		setting_type = "runtime-global",
		order = "8003"
	},
	{
		name = sisyphean.order_item_type.barrelled,
		type = "bool-setting",
		default_value = "true",
		setting_type = "runtime-global",
		order = "8001"
	},
	{
		name = sisyphean.order_item_type.flooring,
		type = "bool-setting",
		default_value = "true",
		setting_type = "runtime-global",
		order = "8004"
	},
	{
		name = sisyphean.order_item_type.uranium_products,
		type = "bool-setting",
		default_value = "true",
		setting_type = "runtime-global",
		order = "8002"
	},
	{
		name = sisyphean.order_item_type.vehicle_turret_ammo,
		type = "bool-setting",
		default_value = "true",
		setting_type = "runtime-global",
		order = "8009"
	},
	{
		name = sisyphean.order_item_type.circuitry,
		type = "bool-setting",
		default_value = "true",
		setting_type = "runtime-global",
		order = "8008"
	},
	{
		name = sisyphean.order_item_type.equipment,
		type = "bool-setting",
		default_value = "true",
		setting_type = "runtime-global",
		order = "8007"
	},
	{
		name = sisyphean.order_item_type.massive,
		type = "bool-setting",
		default_value = "true",
		setting_type = "runtime-global",
		order = "8006"
	},
	{
		name = sisyphean.order_item_type.science,
		type = "bool-setting",
		default_value = "true",
		setting_type = "runtime-global",
		order = "8010"
	}
})