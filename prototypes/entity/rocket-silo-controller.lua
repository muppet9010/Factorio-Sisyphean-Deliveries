local rocket_silo_controller_entity = table.deepcopy(data.raw["lamp"]["small-lamp"])
rocket_silo_controller_entity.name = "rocket-silo-controller"
rocket_silo_controller_entity.minable.result = "rocket-silo-controller"

local rocket_silo_controller_item = table.deepcopy(data.raw.item["constant-combinator"])
rocket_silo_controller_item.name = "rocket-silo-controller"
rocket_silo_controller_item.place_result = "rocket-silo-controller"
rocket_silo_controller_item.order = rocket_silo_controller_item.order .. "-2"
rocket_silo_controller_item.icon = "__base__/graphics/icons/small-lamp.png"

local rocket_silo_controller_recipe = table.deepcopy(data.raw.recipe["constant-combinator"])
rocket_silo_controller_recipe.name = "rocket-silo-controller-recipe"
rocket_silo_controller_recipe.enabled = true
rocket_silo_controller_recipe.result = "rocket-silo-controller"

data:extend{rocket_silo_controller_entity, rocket_silo_controller_item, rocket_silo_controller_recipe}