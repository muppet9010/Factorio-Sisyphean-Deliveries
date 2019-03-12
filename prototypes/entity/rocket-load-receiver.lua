local rocket_load_receiver_entity = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
rocket_load_receiver_entity.name = "rocket-load-receiver"
rocket_load_receiver_entity.minable.result = "rocket-load-receiver"
rocket_load_receiver_entity.item_slot_count = 3

local rocket_load_receiver_item = table.deepcopy(data.raw.item["constant-combinator"])
rocket_load_receiver_item.name = "rocket-load-receiver"
rocket_load_receiver_item.place_result = "rocket-load-receiver"
rocket_load_receiver_item.order = rocket_load_receiver_item.order .. "-1"

local rocket_load_receiver_recipe = table.deepcopy(data.raw.recipe["constant-combinator"])
rocket_load_receiver_recipe.name = "rocket-load-receiver-recipe"
rocket_load_receiver_recipe.enabled = true
rocket_load_receiver_recipe.result = "rocket-load-receiver"

data:extend{rocket_load_receiver_entity, rocket_load_receiver_item, rocket_load_receiver_recipe}