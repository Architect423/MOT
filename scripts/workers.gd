extends Node

var laborers = 0
var proffesionals = 0
var assigned_laborers = 0
var assigned_proffesionals = 0

var worker_types = {
	"Lumberjack": {
		"name": "Lumberjack",
		"label": "Collects wood",
		"base_production_rate": 1,
		"production_rate": 1,
		"production_type": "wood",
		"assigned": 0,
		"type": "laborer",
		"id": 1
	},
		"Teacher": {
		"name": "Teacher",
		"label": "Increases education tier",
		"base_production_rate": 1,
		"production_rate": 1,
		"production_type": "teaching",
		"assigned": 0,
		"type": "proffessional",
		"id": 2
	},
	"Scratcher": {
		"name": "Scratcher",
		"label": "Scratches cave wall",
		"base_production_rate": 1,
		"production_rate": 1,
		"production_type": "scratches",
		"assigned": 0,
		"type": "laborer",
		"id": 3
	},
	"Farmer": {
		"name": "Farmer",
		"label": "Plants on empty tiles and harvests grown tiles",
		"base_production_rate": 1,
		"production_rate": 1,
		"production_type": "farmer",
		"assigned": 0,
		"type": "proffessional",
		"id": 4
	},
	
	"Typist": {
		"name": "Typist",
		"label": "Can type, if they have a typewriter available",
		"base_production_rate": 1,
		"production_rate": 1,
		"production_type": "typist",
		"assigned": 0,
		"type": "proffessional",
		"id": 5
	},
	
	"Editor": {
		"name": "Editor",
		"label": "Can scour all your junk letters to create words",
		"base_production_rate": 1,
		"production_rate": 1,
		"production_type": "editor",
		"assigned": 0,
		"type": "proffessional",
		"id": 6
	},
	
	"Chiseler": {
		"name": "Chiseler",
		"label": "Chisels at the rock for you",
		"base_production_rate": 1,
		"production_rate": 1,
		"production_type": "chiseler",
		"assigned": 0,
		"type": "proffessional",
		"id": 7
	},
}


func _ready():
	SaveSystem.connect("loaded", Callable(self, "_on_SaveSystem_loaded"))

func _on_SaveSystem_loaded():
	load_workers_types()
	pass

func save_workers():
	var workers_dict = {}
	for item_key in worker_types.keys():
		workers_dict[item_key] = {
			"production_rate": worker_types[item_key].production_rate,
			"assigned": worker_types[item_key].assigned,
		}
	SaveSystem.set_var("worker_types", workers_dict)
	SaveSystem.save()

func load_workers_types():
	var loaded_education = SaveSystem.get_var("worker_types", {})
	for item_key in loaded_education.keys():
		if item_key in worker_types:
			worker_types[item_key].production_rate = loaded_education[item_key].get("production_rate", worker_types[item_key].production_rate)
			worker_types[item_key].assigned = loaded_education[item_key].get("assigned", worker_types[item_key].assigned)

