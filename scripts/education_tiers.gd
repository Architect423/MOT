extends Node

var tiers = {
	"Tier1": {
		"name": "Wild:",
		"laborer": false,
		"proffesional": false,
		"quantity": 0,
		"consumed": 0,
		"conversion_rate": 3,
		"tier_down_penalty": .8,
		"teaching": false,
		"id": 1
	},
		"Tier2": {
		"name": "Habituated:",
		"laborer": false,
		"proffesional": false,
		"quantity": 0,
		"consumed": 0,
		"conversion_rate": 6,
		"tier_down_penalty": .8,
		"teaching": false,
		"id": 2
	},
		"Tier3": {
		"name": "Domesticated:",
		"laborer": false,
		"proffesional": false,
		"quantity": 0,
		"consumed": 0,
		"conversion_rate": 9,
		"tier_down_penalty": .8,
		"teaching": false,
		"id": 3
	},
		"Tier4": {
		"name": "Trained:",
		"laborer": true,
		"proffesional": false,
		"quantity": 0,
		"consumed": 0,
		"conversion_rate": 12,
		"tier_down_penalty": .8,
		"teaching": false,
		"id": 4
	},
		"Tier5": {
		"name": "Educated:",
		"laborer": true,
		"proffesional": false,
		"quantity": 0,
		"consumed": 0,
		"conversion_rate": 15,
		"tier_down_penalty": .8,
		"teaching": false,
		"id": 5
	},
		"Tier6": {
		"name": "Proffesional:",
		"laborer": false,
		"proffesional": true,
		"quantity": 0,
		"consumed": 0,
		"conversion_rate": 18,
		"tier_down_penalty": .8,
		"teaching": false,
		"id": 6
	},
}


func _ready():
	SaveSystem.connect("loaded", Callable(self, "_on_SaveSystem_loaded"))

func _on_SaveSystem_loaded():
	load_education_tiers()
	pass

func save_education_tiers():
	var education_dict = {}
	for item_key in tiers.keys():
		education_dict[item_key] = {
			"quantity": tiers[item_key].quantity,
			"consumed": tiers[item_key].consumed,
		}
	SaveSystem.set_var("education_tiers", education_dict)
	SaveSystem.save()

func load_education_tiers():
	var loaded_education = SaveSystem.get_var("education_tiers", {})
	for item_key in loaded_education.keys():
		if item_key in tiers:
			tiers[item_key].quantity = loaded_education[item_key].get("quantity", tiers[item_key].quantity)
			tiers[item_key].consumed = loaded_education[item_key].get("consumed", tiers[item_key].consumed)

