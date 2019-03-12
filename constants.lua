if sisyphean == nil then sisyphean = {} end

sisyphean.setting_name = {
	order_target = "sisyphean-order-target",
	rocket_cargo_size = "sisyphean-rocket-cargo-size",
	order_growth_rate = "sisyphean-order-growth-rate",
	order_growth_size = "sisyphean-order-growth-size",
	order_maximum_size = "sisyphean-order-maximum-size",
	prevent_duplicate_items = "sisyphean-prevent-duplicate-items",
	order_delivery_target_minutes = "sisyphean-order-delivery-target-minutes",
	order_start_target_minutes = "sisyphean-order-start-target-minutes"
}

sisyphean.order_item_type = {
	manual = "sisyphean-order-item-type-manual",
	factory = "sisyphean-order-item-type-factory",
	raw_ingredients = "sisyphean-order-item-type-raw-ingredients",
	barrelled = "sisyphean-order-item-type-barrelled",
	flooring = "sisyphean-order-item-type-flooring",
	uranium_products = "sisyphean-order-item-type-uranium-products",
	vehicle_turret_ammo = "sisyphean-order-item-type-vehicle-turret-ammo",
	circuitry = "sisyphean-order-item-type-circuitry",
	equipment = "sisyphean-order-item-type-equipment",
	massive = "sisyphean-order-item-type-massive",
	science = "sisyphean-order-item-type-science"
}

sisyphean.gui_elem = {
	main_menu_button = "sisyphean_menu_button",
	toggle_completed_orders_button = "sisyphean_orders_show_completed",
	close_finished_frame_button = "sisyphean_finished_frame_close_button",
}

--http://www.december.com/html/spec/colorcodes.html
sisyphean.color = {
	white = {r = 1, g = 1, b = 1, a = 1},

	brightred = {r = 1, g = 0, b = 0, a = 1},
	red = {r = 0.9, g = 0, b = 0, a = 1},
	darkred = {r = 0.8, g = 0, b = 0, a = 1},
	
	green = {r = 0.09, g = 0.7, b = 0, a = 1},
	
	brightorange = {r = 1, g = 0.5, b = 0, a = 1},
	orange = {r = 0.93, g = 0.46, b = 0, a = 1},
	darkorange = {r = 0.8, g = 0.4, b = 0, a = 1},
	dullyellow = {r = 0.85, g = 0.64, b = 0.18, a = 1},
}