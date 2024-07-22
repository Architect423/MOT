extends Node
class_name UpgradeManager

var upgrades = {}

func _ready():
	load_upgrades()
# In UpgradeManager class
func apply_upgrade(resource_name: String, upgrade_type: String, value, quantity: int = 1, upgrade_name: String = "Unnamed Upgrade"):
	if not upgrades.has(resource_name):
		upgrades[resource_name] = {}

	if not upgrades[resource_name].has(upgrade_type):
		upgrades[resource_name][upgrade_type] = []

	upgrades[resource_name][upgrade_type].append({
		"name": upgrade_name,
		"value": value,
		"quantity": quantity
	})
	save_upgrades()

func get_upgrade_value(resource_name: String, upgrade_type: String):
	if not upgrades.has(resource_name) or not upgrades[resource_name].has(upgrade_type):
		return null
	
	return upgrades[resource_name][upgrade_type]

func save_upgrades():
	SaveSystem.set_var("applied_upgrades", upgrades)
	SaveSystem.save()  # This writes the data to the file

func load_upgrades():
	var loaded_upgrades = SaveSystem.get_var("applied_upgrades", {})
	upgrades = loaded_upgrades.get("applied_upgrades", 0)
