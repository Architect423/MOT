# Increments.gd
extends Node

var game_manager: GameManager

func _ready():
	game_manager = get_node("/root/GameManager")  # Adjust the path as needed

func increment_resource(resource_name: String, base_value: int):
	var gained_amount = game_manager.calculate_resource_gain(resource_name, base_value)
	Resources.set(resource_name, Resources.get(resource_name) + gained_amount)

func generate_resource(resource_name: String, base_value: float):
	var gained_amount = game_manager.calculate_resource_gain(resource_name, base_value)
	Resources.set(resource_name, Resources.get(resource_name) + gained_amount)

# Keep your visibility functions as they are
func invisibility(items: Array):
	for item in items:
		item.modulate.a = 0
		
func visibility(items: Array):
	for item in items:
		item.modulate.a = 1


## Increments.gd
#extends Node
#
#func increment_resource(resource_name: String, base_value: int):
#	var global_multiplier = GlobalMultipliers.get(resource_name)
#	var global_adder = GlobalAdders.get(resource_name)
#	if resource_name == "scratches":
#		generate_resource("scratches", 1)
#	Resources.set(resource_name, Resources.get(resource_name) + ((base_value + global_adder) * global_multiplier))
#
#func invisibility(items: Array):
#	for item in items:
#		item.modulate.a = 0
#
#func visibility(items: Array):
#	for item in items:
#		item.modulate.a = 1
#
#func generate_resource(resource_name: String, base_value: float):
#	var gained_amount = resource_calculator.calculate_resource_gain(resource_name, base_value)
#	resources[resource_name] += gained_amount
