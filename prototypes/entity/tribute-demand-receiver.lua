local tribute_order_receiver_entity = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
tribute_order_receiver_entity.name = "tribute-demand-receiver"
tribute_order_receiver_entity.minable.result = "tribute-demand-receiver"
tribute_order_receiver_entity.item_slot_count = 100 --TODO make dynamic, may require change of setting location
--settings.startup[sisyphean.setting_name.order_maximum_size].value + 1

local tribute_order_receiver_item = table.deepcopy(data.raw.item["constant-combinator"])
tribute_order_receiver_item.name = "tribute-demand-receiver"
tribute_order_receiver_item.place_result = "tribute-demand-receiver"
tribute_order_receiver_item.order = tribute_order_receiver_item.order .. "-1"

local tribute_order_receiver_recipe = table.deepcopy(data.raw.recipe["constant-combinator"])
tribute_order_receiver_recipe.name = "tribute-demand-receiver-recipe"
tribute_order_receiver_recipe.enabled = true
tribute_order_receiver_recipe.result = "tribute-demand-receiver"

data:extend{tribute_order_receiver_entity, tribute_order_receiver_item, tribute_order_receiver_recipe}