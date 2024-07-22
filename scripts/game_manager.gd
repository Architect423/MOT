# GameManager.gd
extends Node

var upgrade_manager = UpgradeManager.new()
var resource_calculator = ResourceCalculator.new(upgrade_manager)

func _ready():
	# Initialize upgrades if needed
	pass

# In GameManager
func apply_upgrade(upgrade_target: String, upgrade_type: String, upgrade_value, upgrade_bought, upgrade_name: String):
	upgrade_manager.apply_upgrade(upgrade_target, upgrade_type, upgrade_value, upgrade_bought, upgrade_name)

func calculate_resource_gain(resource_name: String, base_value: float) -> float:
	return resource_calculator.calculate_resource_gain(resource_name, base_value)

# In your game manager or UI script
func format_resource_stats(resource_name: String, base_value: float) -> String:
	var stats = resource_calculator.generate_resource_stats(resource_name, base_value)
	var tooltip = "{resource} Production\n".format({"resource": resource_name.capitalize()})
	tooltip += "Base value: {base}\n".format({"base": stats.base_value})
	tooltip += "Final value: {final}\n\n".format({"final": snapped(stats.final_value, 0.001)})
	tooltip += "Upgrades:\n"

	for upgrade_name in stats.upgrades:
		var upgrade = stats.upgrades[upgrade_name]
		var effect_text = ""
		if upgrade.type == "Additive":
			effect_text = "+{contribution}"
		elif upgrade.type == "Multiplicative":
			effect_text = "x{contribution}"
		elif upgrade.type == "Exponential":
			effect_text = "^{contribution}"
		var upgrade_text = "- {name} ({type}): {effect} (x{quantity})\n"
		var contribution_value = 0.0
		contribution_value = upgrade.total_contribution
		tooltip += upgrade_text.format({
			"name": upgrade_name,
			"type": upgrade.type,
			"effect": effect_text.format({"contribution": snapped(contribution_value, 0.001)}),
			"quantity": upgrade.quantity * upgrade.value
		})
	
	return tooltip
