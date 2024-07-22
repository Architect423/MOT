extends Node

var Rarity = {
	"COMMON":0.85,
	"UNCOMMON": 0.1,
	"RARE": 0.05
}

var zone_list = {
	"Zone1": {
		"name": "Forest",
		"base_hazard_spawn": 10,
		"base_landmark_spawn": 0,
		"base_resource_spawn": 5,
		"max_hazard_spawn": 16,
		"max_landmark_spawn": 2,
		"max_resource_spawn": 7,
		"color": Color.DARK_GREEN,
		"landmarks_needed_to_progress": 1,
		"hazard_damage": 5,
		"id": 1,
		"unlocked": true,
		"potential_resources": {
	 "bananas": {"name": "bananas", "rarity": Rarity.COMMON},
	 "wood": {"name": "wood", "rarity": Rarity.COMMON},
	 "gems": {"name": "gems", "rarity": Rarity.RARE}
 }
	},
	
	"Zone2": {
		"name": "Plains",
		"base_hazard_spawn": 4,
		"base_landmark_spawn": 0,
		"base_resource_spawn": 4,
		"max_hazard_spawn": 8,
		"max_landmark_spawn": 3,
		"max_resource_spawn": 6,
		"color": Color.LIGHT_GREEN,
		"landmarks_needed_to_progress": 10,
		"hazard_damage": 5,
		"id": 2,
		"unlocked": false,
		"potential_resources": {
	 "bananas": {"name": "bananas", "rarity": Rarity.COMMON},
	 "wood": {"name": "wood", "rarity": Rarity.COMMON},
	 "gems": {"name": "gems", "rarity": Rarity.RARE}
 }
	},
"Zone3": {
		"name": "Mountain",
		"base_hazard_spawn": 12,
		"base_landmark_spawn": 0,
		"base_resource_spawn": 1,
		"max_hazard_spawn": 8,
		"max_landmark_spawn": 2,
		"max_resource_spawn": 12,
		"color": Color.DARK_GRAY,
		"landmarks_needed_to_progress": 30,
		"hazard_damage": 15,
		"id": 3,
		"unlocked": false,
		"potential_resources": {
	 "coal": {"name": "coal", "rarity": Rarity.COMMON},
	"gems": {"name": "gems", "rarity": Rarity.UNCOMMON}
 }
	},
}
