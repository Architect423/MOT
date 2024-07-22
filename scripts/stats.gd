extends Node

var tools_broken = 0
var tools_possessed = 0
var current_weather = 1
var current_scavenge_zone = 1
func save_stats():
	var stats = {
		"tools_broken": tools_broken,
		"tools_possessed": tools_possessed,
		"current_weather": current_weather,
		"current_scavenge_zone": current_scavenge_zone,
	}
	SaveSystem.set_var("stats", stats)
	SaveSystem.save()  # This writes the data to the file

func load_stats():
	var loaded_stats = SaveSystem.get_var("stats", {})
	tools_broken = loaded_stats.get("tools_broken", 0)
	tools_possessed = loaded_stats.get("tools_possessed", 0)
	current_weather = loaded_stats.get("current_weather", 0)
	current_scavenge_zone = loaded_stats.get("current_scavenge_zone", 1)
