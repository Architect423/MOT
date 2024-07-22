extends Node

var shop_items = {
	"IncreaseSize": {
		"name": "Increase Size",
		"label": "Expand your operation by condensing all of your farm tiles into a single tile",
		"cost": 100,
		"units": "bananas",
		"grid": "farm",
		"unlocked": true,
		"bought": 0,
		"visible": false,
		"max_qty": 2,
		"id": 1,
		"unlock_cost": 40,
		"unlock_currency": "bananas",
		"upgrade_type": "Multiplicative",
		"upgrade_value": 9,
		"upgrade_target": "bananas",
		"custom_cost_scale": [100, 5000, 15000]
	},
	"Fertilizer": {
		"name": "Fertilizer",
		"label": "Rapidly increase the rate of growth",
		"cost": 25,
		"units": "bananas",
		"grid": "farm",
		"unlocked": true,
		"bought": 0,
		"visible": false,
		"max_qty": 10,
		"id": 2,
		"unlock_cost": 10,
		"unlock_currency": "bananas",
	},
	"Hoe": {
		"name": "Hoe",
		"label": "Planting a banana also plants adjacent fields if not already growing",
		"cost": 150,
		"units": "bananas",
		"grid": "farm",
		"unlocked": true,
		"bought": 0,
		"visible": false,
		"max_qty": 1,
		"id": 3,
		"unlock_cost": 100,
		"unlock_currency": "bananas"
	},
	"Insulation": {
		"name": "Insulation",
		"label": "Stoking the flames decays slower",
		"cost": 5,
		"units": "wood",
		"grid": "forge",
		"unlocked": true,
		"bought": 0,
		"visible": false,
		"max_qty": 10,
		"id": 4,
		"unlock_cost": 10,
		"unlock_currency": "scratches"
	},
	"Preparations": {
		"name": "Preparations",
		"label": "Ignore the first hazard encountered during each scavenge run",
		"cost": 5,
		"units": "bananas",
		"grid": "scavenge",
		"unlocked": true,
		"bought": 0,
		"visible": false,
		"max_qty": 1,
		"id": 5,
		"unlock_cost": 10,
		"unlock_currency": "scratches"
	},
	"NaturalRemedies": {
		"name": "Natural Remedies",
		"label": "Scavenging Resources occasionally gives a small amount of health",
		"cost": 5,
		"units": "wood",
		"grid": "scavenge",
		"unlocked": true,
		"bought": 0,
		"visible": false,
		"max_qty": 5,
		"id": 6,
		"unlock_cost": 10,
		"unlock_currency": "scratches",
		"upgrade_type": "Additive",
		"upgrade_value": 1,
		"upgrade_target": "health"
	},
	"ObsidianChunk": {
		"name": "Obsidian Chunk",
		"label": "Increase manual scratching rate",
		"cost": 10,
		"units": "scratches",
		"grid": "scratch",
		"unlocked": true,
		"bought": 0,
		"visible": false,
		"max_qty": 10,
		"id": 7,
		"unlock_cost": 10,
		"unlock_currency": "scratches",
		"upgrade_type": "Multiplicative",
		"upgrade_value": 1.2,
		"upgrade_target": "scratches"
	},
	"CombustionVessel": {
		"name": "Combustion Vessel",
		"label": "Increases max fuel capacity",
		"cost": 5,
		"units": "coal",
		"grid": "forge",
		"unlocked": true,
		"bought": 0,
		"visible": false,
		"max_qty": 10,
		"id": 8,
		"unlock_cost": 10,
		"unlock_currency": "scratches"
	},
	"Blower": {
		"name": "Blower",
		"label": "Stoking is more efficient",
		"cost": 5,
		"units": "coal",
		"grid": "forge",
		"unlocked": true,
		"bought": 0,
		"visible": false,
		"max_qty": 10,
		"id": 9,
		"unlock_cost": 10,
		"unlock_currency": "scratches"
	},
	"CombiningScratches": {
		"name": "Combining Scratches",
		"label": "Scratch multiple times in the same area allowing you to create complex symbols",
		"cost": 500,
		"units": "scratches",
		"grid": "scratch",
		"unlocked": false,
		"bought": 1,
		"visible": false,
		"max_qty": 9,
		"id": 10,
		"unlock_cost": 200000,
		"unlock_currency": "scratches"
	},
	"Scavenger": {
		"name": "Scavenger",
		"label": "Unlock the scavenging tile",
		"cost": 20000,
		"units": "scratches",
		"grid": "scratch",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 1,
		"id": 11,
		"unlock_cost": 5000,
		"unlock_currency": "scratches",
		"upgrade_type": "SimpleVisibility",
		"upgrade_target": []
	},
	"ScavengerTraining": {
		"name": "Scavenger Training",
		"label": "Unlock upgrades for scavenging",
		"cost": 10,
		"units": "bananas",
		"grid": "scratch",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 1,
		"id": 12,
		"unlock_cost": 1,
		"unlock_currency": "bananas",
		"upgrade_type": "SimpleVisibility",
		"upgrade_target": []
	},
	"NaturalFracture": {
		"name": "Natural Fracture",
		"label": "Chance to double your scratches on each manual click",
		"cost": 100,
		"units": "scratches",
		"grid": "scratch",
		"unlocked": true,
		"bought": 0,
		"visible": false,
		"max_qty": 10,
		"id": 13,
		"unlock_cost": 50,
		"unlock_currency": "scratches"
	},
	"BrickExtensions": {
		"name": "Brick Extensions",
		"label": "Increase maximum stoke",
		"cost": 10,
		"units": "scratches",
		"grid": "forge",
		"unlocked": true,
		"bought": 0,
		"visible": false,
		"max_qty": 10,
		"id": 14,
		"unlock_cost": 10,
		"unlock_currency": "scratches"
	},
	"GeodeCracker": {
		"name": "Geode Cracker",
		"label": "Small chance that broken rocks will contain gems",
		"cost": 100,
		"units": "scratches",
		"grid": "scratch",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 1,
		"id": 15,
		"unlock_cost": 40000,
		"unlock_currency": "scratches"
	},
	"ChiselUpgrade": {
		"name": "Chisel",
		"label": "Instead of just scratching lines, try and knock off some edges and crags",
		"cost": 150,
		"units": "scratches",
		"grid": "scratch",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 1,
		"id": 16,
		"unlock_cost": 70,
		"unlock_currency": "scratches"
	},
	
	"Meteorology": {
		"name": "Meteorology",
		"label": "You can sense the weather",
		"cost": 100,
		"units": "scratches",
		"grid": "scavenge",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 1,
		"id": 17,
		"unlock_cost": 10,
		"unlock_currency": "scratches",
		"upgrade_type": "SimpleVisibility",
		"upgrade_target": []
	},
	
	"Farm": {
		"name": "Farm",
		"label": "Unlock Farm",
		"cost": 120,
		"units": "bananas",
		"grid": "scavenge",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 1,
		"id": 18,
		"unlock_cost": 15,
		"unlock_currency": "bananas",
		"upgrade_type": "SimpleVisibility",
		"upgrade_target": []
	},
	
#	"Discovery": {
#		"name": "Discovery",
#		"label": "Unlock Discovery",
#		"cost": 10,
#		"units": "scratches",
#		"grid": "scratch",
#		"unlocked": false,
#		"bought": 0,
#		"visible": false,
#		"max_qty": 1,
#		"id": 19,
#		"unlock_cost": 100000,
#		"unlock_currency": "scratches",
#		"upgrade_type": "SimpleVisibility",
#		"upgrade_target": []
#	},
	
	"Furnace": {
		"name": "Furnace",
		"label": "Unlock Furnace",
		"cost": 1000,
		"units": "wood",
		"grid": "scavenge",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 1,
		"id": 20,
		"unlock_cost": 500,
		"unlock_currency": "wood",
		"upgrade_type": "SimpleVisibility",
		"upgrade_target": []
	},
	
	"Monkeys": {
		"name": "Monkeys",
		"label": "Unlock Monkeys",
		"cost": 1500,
		"units": "bananas",
		"grid": "farm",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 1,
		"id": 21,
		"unlock_cost": 1000,
		"unlock_currency": "bananas",
		"upgrade_type": "SimpleVisibility",
		"upgrade_target": []
	},
	
	"PackedCamp": {
		"name": "Packed Camp",
		"label": "You can scavenge for a longer distance",
		"cost": 5,
		"units": "bananas",
		"grid": "scavenge",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 20,
		"id": 22,
		"unlock_cost": 1,
		"unlock_currency": "bananas"
	},
	"Dripstone": {
		"name": "Dripstone",
		"label": "Occasionally drips water onto your equipped tool, decreasing its durability and leaving a mark at the same time",
		"cost": 250,
		"units": "scratches",
		"grid": "scratch",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 1,
		"id": 23,
		"unlock_cost": 200,
		"unlock_currency": "scratches",
		"upgrade_type": "SimpleVisibility",
		"upgrade_target": []
	},
	"DripSpeed": {
		"name": "Dripstone Speed",
		"label": "Speed up the time between drips",
		"cost": 550,
		"units": "scratches",
		"grid": "scratch",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 10,
		"id": 24,
		"unlock_cost": 300,
		"unlock_currency": "scratches"
	},
	"ToolAutoEquip": {
		"name": "Auto Equip",
		"label": "If your tool breaks, automatically equip a new one",
		"cost": 3000,
		"units": "scratches",
		"grid": "scratch",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 1,
		"id": 25,
		"unlock_cost": 2000,
		"unlock_currency": "scratches",
		"upgrade_type": "SimpleVisibility",
		"upgrade_target": []
	},
	
	"WaterBasin": {
		"name": "Water Basin",
		"label": "Your dripstone drip frequency is increased during bad weather",
		"cost": 50,
		"units": "wood",
		"grid": "scratch",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 1,
		"id": 26,
		"unlock_cost": 10,
		"unlock_currency": "wood",
		"prerequisites": ["Meteorology", "Dripstone"]
	},
	
	"SharpeningTools": {
		"name": "Sharpened Tools",
		"label": "Tool effectiveness is increased",
		"cost": 1000,
		"units": "scratches",
		"grid": "scratch",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 10,
		"id": 27,
		"unlock_cost": 4000,
		"unlock_currency": "scratches"
	},
	
	"ShinyRocks": {
		"name": "Shiny Rocks",
		"label": "Increase chance to get a shiny tool",
		"cost": 1000,
		"units": "scratches",
		"grid": "scratch",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 10,
		"id": 28,
		"unlock_cost": 2500,
		"unlock_currency": "scratches"
	},
	
	"SkilledGatherer": {
		"name": "Skilled Gatherer",
		"label": "Increases the amount of bananas found from resource nodes",
		"cost": 3000,
		"units": "scratches",
		"grid": "scavenge",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 10,
		"id": 29,
		"unlock_cost": 5,
		"unlock_currency": "bananas"
	},
	
	"SelectiveHarvesting": {
		"name": "Selective Harvesting",
		"label": "Banana trees grow bigger bushels",
		"cost": 50,
		"units": "bananas",
		"grid": "farm",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 10,
		"id": 30,
		"unlock_cost": 25,
		"unlock_currency": "bananas"
	},
	
	"ChiseledPot": {
		"name": "Chiseled Pot",
		"label": "Increase the size of the dripstones droplets",
		"cost": 500,
		"units": "scratches",
		"grid": "scratch",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 5,
		"id": 31,
		"unlock_cost": 400,
		"unlock_currency": "scratches",
		"prerequisites": ["ChiselUpgrade", "Dripstone"]
	},
	
	"CrudeFunnel": {
		"name": "Crude Funnel",
		"label": "Droplets fall faster",
		"cost": 10,
		"units": "wood",
		"grid": "scratch",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 10,
		"id": 32,
		"unlock_cost": 25,
		"unlock_currency": "wood",
		"prerequisites": ["ChiselUpgrade", "Dripstone"]
	},
	
	"Breeding": {
		"name": "Breeding",
		"label": "If you have more than 100 monkeys in a tier, they have a chance to breed diminishing with education tier",
		"cost": 8000,
		"units": "bananas",
		"grid": "farm",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 1,
		"id": 33,
		"unlock_cost": 5000,
		"unlock_currency": "bananas",
		"prerequisites": ["Monkeys"]
	},
	
	"PrimitiveHuts": {
		"name": "Primitive Huts",
		"label": "Reduce the breeding interval",
		"cost": 200,
		"units": "wood",
		"grid": "farm",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 10,
		"id": 34,
		"unlock_cost": 100,
		"unlock_currency": "wood",
		"prerequisites": ["Breeding"]
	},
	
	"CrudeBed": {
		"name": "Crude Bed",
		"label": "Gain additional monkeys when breeding",
		"cost": 300,
		"units": "wood",
		"grid": "farm",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 10,
		"id": 34,
		"unlock_cost": 200,
		"unlock_currency": "wood",
		"prerequisites": ["Breeding"]
	},
	
	"Propogation": {
		"name": "Propogation",
		"label": "Occasionally, harvesting will net rewards but not reset the tile",
		"cost": 1250,
		"units": "bananas",
		"grid": "farm",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 10,
		"id": 34,
		"unlock_cost": 700,
		"unlock_currency": "wood"
	},
	
	"Scythe": {
		"name": "Scythe",
		"label": "Harvesting a banana also harvests adjacent fields if ready to harvest",
		"cost": 1250,
		"units": "bananas",
		"grid": "farm",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 1,
		"id": 34,
		"unlock_cost": 700,
		"unlock_currency": "wood"
	},
	
	"GrowingSeason": {
		"name": "Growing Season",
		"label": "Harvesting during good weather yields more bananas",
		"cost": 800,
		"units": "bananas",
		"grid": "farm",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 5,
		"id": 35,
		"unlock_cost": 40000,
		"unlock_currency": "scratches",
		"prerequisites": ["Meteorology", "Farm"]
	},
	
	"StumpHarvest": {
		"name": "Stump Harvesting",
		"label": "When harvesting bananas, occasionally get a stump to use as a tool",
		"cost": 200,
		"units": "wood",
		"grid": "farm",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 5,
		"id": 35,
		"unlock_cost": 60000,
		"unlock_currency": "scratches",
		"prerequisites": ["Farm"]
	},
	
	"HandSaw": {
		"name": "Hand Saw",
		"label": "Gain bonus wood when scavenging",
		"cost": 5000,
		"units": "scratches",
		"grid": "scavenge",
		"unlocked": false,
		"bought": 0,
		"visible": false,
		"max_qty": 10,
		"id": 35,
		"unlock_cost": 20000,
		"unlock_currency": "scratches",
		"prerequisites": ["Monkeys"]
	},
	# Add more shop items here
}

func _ready():
	SaveSystem.connect("loaded", Callable(self, "_on_SaveSystem_loaded"))

func _on_SaveSystem_loaded():
	load_upgrades()
	pass

func save_upgrades():
	var upgrades_dict = {}
	for item_key in shop_items.keys():
		upgrades_dict[item_key] = {
			"cost": shop_items[item_key].cost,
			"unlocked": shop_items[item_key].unlocked,
			"bought": shop_items[item_key].bought
		}
	SaveSystem.set_var("upgrades", upgrades_dict)
	SaveSystem.save()

func load_upgrades():
	var loaded_upgrades = SaveSystem.get_var("upgrades", {})
	for item_key in loaded_upgrades.keys():
		if item_key in shop_items:
			shop_items[item_key].cost = loaded_upgrades[item_key].get("cost", shop_items[item_key].cost)
			shop_items[item_key].unlocked = loaded_upgrades[item_key].get("unlocked", false)
			shop_items[item_key].bought = loaded_upgrades[item_key].get("bought", 0)
