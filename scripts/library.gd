extends Node

var typewriters = 0
var computers = 0

func save_library():
	var library = {
		"typewriters": typewriters,
		"computers": computers,
	}
	SaveSystem.set_var("library", library)
	SaveSystem.save()  # This writes the data to the file

func load_library():
	var loaded_library = SaveSystem.get_var("library", {})
	typewriters = loaded_library.get("typewriters", 0)
	computers = loaded_library.get("computers", 0)
