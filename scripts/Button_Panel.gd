extends PanelContainer
var scratches = 0
@onready var chisel_progress = %chisel_progress
@onready var chisel_btn = %chisel_btn

var drip
# Called when the node enters the scene tree for the first time.
func _ready():
	chisel_progress.modulate.a = 0
	chisel_btn.modulate.a = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	chisel_progress.value = chisel_pct
	if Stats.tools_broken > 3:
		Upgrades.shop_items["GeodeCracker"].unlocked = true
	if Resources.scratches > 30:
		Upgrades.shop_items["ChiselUpgrade"].unlocked = true
	if Upgrades.shop_items["ChiselUpgrade"].bought == 1:
		Increments.visibility([chisel_btn, chisel_progress])

func _on_button_pressed():
	var sharp_multiplier = 1
	Console.messages.append("Clicked Button")
	if Upgrades.shop_items["SharpeningTools"].bought > 0:
		sharp_multiplier = pow(1.1, Upgrades.shop_items["SharpeningTools"].bought)
	var tool_multiplier = 1
	if Tools.equipped_tool:
		Tools.equipped_tool["Durability"] -= 1
		tool_multiplier = Tools.equipped_tool["Toughness"] * sharp_multiplier
		if Tools.equipped_tool["name"] == "Wood Stump":
			Increments.increment_resource("wood", 5)
	var local_multipier = _fracture() * tool_multiplier 
	Increments.increment_resource("scratches", local_multipier)
	Resources.segments = Upgrades.shop_items["CombiningScratches"].bought
	if Resources.scratches > 250:
		Upgrades.shop_items["Scavenger"].unlocked = true

func _fracture():
	var roll = randi_range(0, 100)
	var base_chance = 5
	var upgrade_chance = 2
	if Upgrades.shop_items["NaturalFracture"].bought > 0:
		if roll < (Upgrades.shop_items["NaturalFracture"].bought - 1) * upgrade_chance + base_chance:
			return 2
		else:
			return 1
	else:
		return 1
	

signal spawn_rock(rarity)
var chisel_pct = 0
func _on_chisel_btn_pressed():
	var chisel_multiplier = 1
	if chisel_pct < 100:
		if Tools.equipped_tool:
			Tools.equipped_tool["Durability"] -= 1
			chisel_multiplier = Tools.equipped_tool["Toughness"]
		chisel_pct += 10 * (chisel_multiplier)
	else:
		if Stats.tools_possessed < 5:
			spawn_rock.emit()
			chisel_pct = 0


func _on_tool_panel_dripped():
	var i = 0
	while i < (Upgrades.shop_items["ChiseledPot"].bought + 1):
		_on_button_pressed()
		i += 1


func _on_worker_panel_chiseler():
	_on_chisel_btn_pressed()
	pass # Replace with function body.
