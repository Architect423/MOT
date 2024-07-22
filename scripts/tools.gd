extends Node

var equipped_tool

var Rarity = {
	"COMMON":0.85,
	"UNCOMMON": 0.01,
	"RARE": 0.00,
	"ULTRA": 0.00
}

var tool_templates = {
	"PebbleTemplate": {
		"name": "Pebble",
		"Durability": 10,
		"Toughness": 2,
		"color": Color.DARK_SLATE_GRAY,
		"rarity": Rarity.COMMON,
		"id": 1
	},
		"RockTemplate": {
		"name": "Rock",
		"Durability": 50,
		"Toughness": 4,
		"color": Color.SLATE_GRAY,
		"rarity": Rarity.COMMON,
		"id": 2
	},
	
		"ShinyPebbleTemplate": {
		"name": "Shiny Pebble",
		"Durability": 10,
		"Toughness": 10,
		"color": Color.DARK_GOLDENROD,
		"rarity": Rarity.UNCOMMON,
		"id": 3
	},
	
	"ShinyRockTemplate": {
		"name": "Shiny Rock",
		"Durability": 50,
		"Toughness": 20,
		"color": Color.GOLDENROD,
		"rarity": Rarity.UNCOMMON,
		"id": 4
	},
	
	"WoodenStump": {
		"name": "Wood Stump",
		"Durability": 200,
		"Toughness": 8,
		"color": Color.SADDLE_BROWN,
		"rarity": Rarity.ULTRA,
		"id": 4
	},
}
