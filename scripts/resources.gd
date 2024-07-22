extends Node

var bananas = 0
var scratches = 0
var coal = 0
var health = 0
var wood = 0
var segments = 1
var pelts = 0
var gems = 0
var letters = 0
var words = 0
func save_resources():
	var resources_dict = {
		"scratches": scratches,
		"wood": wood,
		"bananas": bananas,
		"coal": coal,
		"health": health,
		"segments": segments,
		"pelts": pelts,
		"gems": gems
	}
	SaveSystem.set_var("resources", resources_dict)
	SaveSystem.save()  # This writes the data to the file

func load_resources():
	var loaded_resources = SaveSystem.get_var("resources", {})
	scratches = loaded_resources.get("scratches", 0)
	wood = loaded_resources.get("wood", 0)
	bananas = loaded_resources.get("bananas", 0)
	coal = loaded_resources.get("coal", 0)
	health = loaded_resources.get("health", 0)
	segments = loaded_resources.get("segments", 1)
	pelts = loaded_resources.get("pelts", 0)
	gems = loaded_resources.get("gems", 0)
	
func _ready():
	SaveSystem.connect("loaded", Callable(self, "_on_SaveSystem_loaded"))

func _on_SaveSystem_loaded():
	load_resources()
	pass
