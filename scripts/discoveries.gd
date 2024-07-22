extends Node

var letters = {
	"A": {
		"name": "A",
		"label": "A",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Permanently unlock the monkeys panel",
		"discoverable": false,
		"segments": 8,
		"id": 1
	},
	"B": {
		"name": "B",
		"label": "B",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Start with 'Scythe' unlocked",
		"discoverable": false,
		"segments": 9,
		"id": 2
	},
	"C": {
		"name": "C",
		"label": "C",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Start with one trained monkey",
		"discoverable": false,
		"segments": 6,
		"id": 3
	},
	"D": {
		"name": "D",
		"label": "D",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Permanently unlock the scavenge panel",
		"discoverable": false,
		"segments": 8,
		"id": 4
	},
	"E": {
		"name": "E",
		"label": "E",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Start with 'Crude Funnel' fully upgraded",
		"discoverable": false,
		"segments": 7,
		"id": 5
	},
	"F": {
		"name": "F",
		"label": "F",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Start with 50 bananas",
		"discoverable": false,
		"segments": 5,
		"id": 6
	},
	"G": {
		"name": "G",
		"label": "G",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Increase tool capacity by 5",
		"discoverable": false,
		"segments": 8,
		"id": 7
	},
	"H": {
		"name": "H",
		"label": "H",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Start with 1000 scratches",
		"discoverable": false,
		"segments": 6,
		"id": 8
	},
	"I": {
		"name": "I",
		"label": "I",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Permanently unlock the scavenge panel",
		"discoverable": false,
		"segments": 6,
		"id": 9
	},
	"J": {
		"name": "J",
		"label": "J",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Get 2x wood from scavenging",
		"discoverable": false,
		"segments": 5,
		"id": 10
	},
	"K": {
		"name": "K",
		"label": "K",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Cap the weather at a max of 80%",
		"discoverable": false,
		"segments": 5,
		"id": 11
	},
	"L": {
		"name": "L",
		"label": "L",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Permanently unlock the dripstone",
		"discoverable": false,
		"segments": 4,
		"id": 12
	},
	"M": {
		"name": "M",
		"label": "M",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Cap to start breeding reduced by 10%",
		"discoverable": false,
		"segments": 6,
		"id": 13
	},
	"N": {
		"name": "N",
		"label": "N",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Permanently unlock the farm panel",
		"discoverable": false,
		"segments": 6,
		"id": 14
	},
	"O": {
		"name": "O",
		"label": "O",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Permanently unlock the scavenge panel",
		"discoverable": false,
		"segments": 8,
		"id": 15
	},
	"P": {
		"name": "P",
		"label": "P",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Start with one proffesional",
		"discoverable": false,
		"segments": 7,
		"id": 16
	},
	"Q": {
		"name": "Q",
		"label": "Q",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Permanently unlock the scavenge panel",
		"discoverable": false,
		"segments": 9,
		"id": 17
	},
	"R": {
		"name": "R",
		"label": "R",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Permanently unlock the scavenge panel",
		"discoverable": false,
		"segments": 8,
		"id": 18
	},
	"S": {
		"name": "S",
		"label": "S",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Permanently unlock the scavenge panel",
		"discoverable": false,
		"segments": 8,
		"id": 19
	},
	"T": {
		"name": "T",
		"label": "T",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Start with 3 Shiny Pebbles",
		"discoverable": false,
		"segments": 4,
		"id": 20
	},
	"U": {
		"name": "U",
		"label": "U",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Farming bananas also drops some wood",
		"discoverable": false,
		"segments": 6,
		"id": 21
	},
	"V": {
		"name": "V",
		"label": "V",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Start with 5 levels in 'Packed Camp'",
		"discoverable": false,
		"segments": 4,
		"id": 22
	},
	"W": {
		"name": "W",
		"label": "W",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Start with 100 wood",
		"discoverable": false,
		"segments": 6,
		"id": 23
	},
	"X": {
		"name": "X",
		"label": "X",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Start with a Shiny Rock",
		"discoverable": false,
		"segments": 4,
		"id": 24
	},
	"Y": {
		"name": "Y",
		"label": "Y",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Start with 'Hoe' unlocked",
		"discoverable": false,
		"segments": 7,
		"id": 25
	},
	"Z": {
		"name": "Z",
		"label": "Z",
		"chance": 0.1,
		"discovered": false,
		"activated": false,
		"prestige_effect_desc": "Start with an iron pickaxe",
		"discoverable": false,
		"segments": 6,
		"id": 26
	},

}

func _ready():
	SaveSystem.connect("loaded", Callable(self, "_on_SaveSystem_loaded"))

func _on_SaveSystem_loaded():
	load_discoveries()
	pass

func save_discoveries():
	var letters_dict = {}
	for item_key in letters.keys():
		letters_dict[item_key] = {
			"discovered": letters[item_key].discovered,
			"activated": letters[item_key].activated,
			"discoverable": letters[item_key].discoverable
		}
	SaveSystem.set_var("discoveries", letters_dict)
	SaveSystem.save()

func load_discoveries():
	var loaded_discoveries = SaveSystem.get_var("discoveries", {})
	for item_key in loaded_discoveries.keys():
		if item_key in letters:
			letters[item_key].discovered = loaded_discoveries[item_key].get("discovered", false)
			letters[item_key].activated = loaded_discoveries[item_key].get("activated", false)
			letters[item_key].discoverable = loaded_discoveries[item_key].get("discoverable", false)

