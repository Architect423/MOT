extends Node
class_name ResourceCalculator

var upgrade_manager: UpgradeManager

func _init(manager: UpgradeManager):
	upgrade_manager = manager

func calculate_resource_gain(resource_name: String, base_value: float) -> float:
	var final_value = base_value
	
	# Apply additive upgrades
	var additive_upgrades = upgrade_manager.get_upgrade_value(resource_name, "Additive")
	if additive_upgrades:
		for upgrade in additive_upgrades:
			final_value += upgrade.value * upgrade.quantity
	
	# Apply multiplicative upgrades
	var multiplicative_upgrades = upgrade_manager.get_upgrade_value(resource_name, "Multiplicative")
	if multiplicative_upgrades:
		var total_multiplier = 1.0
		for upgrade in multiplicative_upgrades:
			total_multiplier += (upgrade.value - 1) * upgrade.quantity  # Subtract 1 to get the bonus
		final_value *= total_multiplier
	
	# Apply exponential upgrades
	var exponential_upgrades = upgrade_manager.get_upgrade_value(resource_name, "Exponential")
	if exponential_upgrades:
		var total_exponent = 1.0
		for upgrade in exponential_upgrades:
			total_exponent += (upgrade.value - 1) * upgrade.quantity  # Subtract 1 to get the bonus
		final_value = pow(final_value, total_exponent)
	return final_value

# In ResourceCalculator class
func generate_resource_stats(resource_name: String, base_value: float) -> Dictionary:
	var stats = {
		"base_value": base_value,
		"final_value": base_value,
		"additive": 0.0,
		"multiplicative": 1.0,
		"exponential": 1.0,
		"upgrades": {}
	}

	# Process all upgrade types
	for upgrade_type in ["Additive", "Multiplicative", "Exponential"]:
		var upgrades = upgrade_manager.get_upgrade_value(resource_name, upgrade_type)
		if upgrades:
			for upgrade in upgrades:
				var upgrade_name = upgrade.get("name", "Unnamed Upgrade")
				if not stats.upgrades.has(upgrade_name):
					stats.upgrades[upgrade_name] = {
						"type": upgrade_type,
						"value": upgrade.value,
						"quantity": 0,
						"total_contribution": 0.0
					}

				stats.upgrades[upgrade_name].quantity = upgrade.quantity

				var contribution = 0.0
				if upgrade_type == "Additive":
					contribution = upgrade.value * upgrade.quantity
					stats.additive = contribution
				elif upgrade_type == "Multiplicative":
					contribution = (upgrade.value) * upgrade.quantity
					stats.multiplicative = contribution
				elif upgrade_type == "Exponential":
					contribution = (upgrade.value - 1) * upgrade.quantity
					stats.exponential = contribution

				stats.upgrades[upgrade_name].total_contribution = upgrade.quantity
	# Calculate final value
	if stats.multiplicative > 0:
		stats.final_value = (base_value + stats.additive) * (stats.multiplicative)
	else:
		stats.final_value = (base_value + stats.additive)
	if stats.exponential > 0:
		stats.final_value = pow(stats.final_value, stats.exponential)

	return stats
