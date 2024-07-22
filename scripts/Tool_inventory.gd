extends PanelContainer
@onready var mouse_marker = %Mouse_marker
@onready var grid_container = %tool_grid
@onready var dripstone_enable = %dripstone_enable
@onready var dripstone_box = %dripstone_box
@onready var tool_autoequip_box = %tool_autoequip_box
@onready var tool_autoequip = %tool_autoequip

@onready var tool_slot = %tool_slot


var mouse_hovering = {}
var inventory_items ={}
var tool_data = {}
var tool_slot_hovered = false
var tool_equipped = {}
var drip
@onready var dripstone_equipped = %dripstone_equipped

# Called when the node enters the scene tree for the first time.
func _ready():
	Stats.load_stats()
	load_tools()
	Tools.Rarity["COMMON"] = .95
	Tools.Rarity["UNCOMMON"] = .05
	Tools.Rarity["RARE"] = .0
	Upgrades.shop_items["Dripstone"].upgrade_target = [dripstone_box]
	Upgrades.shop_items["ToolAutoEquip"].upgrade_target = [tool_autoequip_box]
	self.modulate.a = 0
	drip = ColorRect.new()
	drip.custom_minimum_size = Vector2(5, 5)
	drip.z_index = 4
	drip.color = Color.BLUE
	drip.position = Vector2(15, 75)  # Adjust these values to position the drip above the tool_slot
	drip.visible = false
	tool_slot.add_child(drip)
	var drip_timer = Timer.new()
	drip_timer.name = "DripTimer"
	drip_timer.one_shot = true
	add_child(drip_timer)

func _on_mouse_entered(item):
	mouse_hovering[item] = true
	var rect_tool = tool_data[item].rect
	rect_tool.tooltip_text = "%s\nDurability: %d\nToughness: %d" % [
	tool_data[item].name,
	tool_data[item].Durability,
	tool_data[item].Toughness
	]
	

@onready var null_obj = %NULL

func _on_mouse_exited(item):
	mouse_hovering[item] = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
var dripstone_base_interval = 5
var dripstone_interval = 5
var dripping_base_interval = 2
var dripping_interval = 2

func _process(delta):
	print(Stats.tools_possessed)
	if Upgrades.shop_items["CrudeFunnel"].bought > 0:
		dripping_interval = 1 + (10 - Upgrades.shop_items["CrudeFunnel"].bought) / 10
	if Upgrades.shop_items["ShinyRocks"].bought > 0:
		Tools.Rarity["UNCOMMON"] = Upgrades.shop_items["ShinyRocks"].bought * .02 + .05
		Tools.Rarity["COMMON"] = 1 - Tools.Rarity["UNCOMMON"]
	if Upgrades.shop_items["DripSpeed"].bought > 0:
		var water_basin = 0
		if Upgrades.shop_items["WaterBasin"].bought > 0:
			water_basin = Stats.current_weather / 100
		dripstone_interval = (dripstone_base_interval * pow(.9, Upgrades.shop_items["DripSpeed"].bought)) - water_basin
	for item in inventory_items:
		if item:
			self.modulate.a = 1
			if inventory_items[item].get_parent() == tool_slot:
				tool_equipped[item] = true
				if Tools.equipped_tool and Tools.equipped_tool["Durability"] != tool_data[item].Durability:
					tool_data[item].Durability = Tools.equipped_tool["Durability"]
					save_tools()
				if dripstone_enable.button_pressed:
					start_drip_animation()			
			else:
				tool_equipped[item] = false
				if Tools.equipped_tool == tool_data[item]:
					Tools.equipped_tool = null

			if mouse_hovering[item]:
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
					if inventory_items[item].get_parent() == tool_slot || grid_container:
						if mouse_marker.get_children() == []:
							inventory_items[item].reparent(mouse_marker)
				else:
					if inventory_items[item].get_parent() == mouse_marker:
						if tool_slot_hovered:
							if tool_slot.get_child(2) == null:
								inventory_items[item].reparent(tool_slot)
							else:
								inventory_items[item].reparent(grid_container)
						else:
							inventory_items[item].reparent(grid_container)			
			if tool_equipped[item]:
				if Tools.equipped_tool ==  null:
						Tools.equipped_tool = tool_data[item].duplicate()
						save_tools()
				if Tools.equipped_tool["Durability"] <= 0:
					save_tools()
					Stats.tools_broken += 1
					_roll_gems()
					inventory_items[item].queue_free()
					inventory_items.erase(item)
					Tools.equipped_tool = null
					tool_equipped[item] = false
					tool_data.erase(item)
					Stats.tools_possessed -= 1
					Stats.save_stats()
								# Auto-equip logic
					if Upgrades.shop_items["ToolAutoEquip"].bought == 1:
						if tool_autoequip.button_pressed:
							var next_tool = find_next_tool()
							if next_tool:
								inventory_items[next_tool].reparent(tool_slot)
								inventory_items[next_tool].global_position = tool_slot.global_position
							
func find_next_tool():
	for item in inventory_items:
		if inventory_items[item].get_parent() == grid_container:
			return item
	return null


func _on_tool_slot_mouse_entered():
	tool_slot_hovered = true

func _roll_gems():
	if Upgrades.shop_items["GeodeCracker"].bought > 0:
		var roll = randi_range(0, 100)
		if roll <= Upgrades.shop_items["GeodeCracker"].bought:
			Increments.increment_resource("gems", 1)

func _on_tool_slot_mouse_exited():
	tool_slot_hovered = false


func _on_button_panel_spawn_rock():
	_spawn_rock()

func start_drip_animation():
	var drip_timer = $DripTimer
	if not drip_timer.is_stopped():
		return  # If the timer is still running, don't start a new animation

	if drip.visible == false:
		drip.visible = true
		drip.position.y = -55  # Reset the position

		var tween = create_tween()
		tween.tween_property(drip, "position:y", 20, dripping_interval)  # Move down 20 pixels over 2 seconds
		tween.tween_callback(reset_drip)

	# Start the timer for the next drip
	drip_timer.start(dripstone_interval)  # 3 second delay, adjust as needed

signal dripped

func reset_drip():
	drip.visible = false
	dripped.emit()
	
var name_index = 0
func _spawn_rock(type : String = "random"):
	Stats.tools_possessed += 1
	Stats.save_stats()
	var item_name = "Tool"
	var item_random_selection
	if type == "random":
		item_random_selection = WeightedChoice.pick(Tools.tool_templates, "rarity")
	elif type == "wood":
		item_random_selection = "WoodenStump"
	var item = item_name + str(name_index)
	mouse_hovering[item] = false
	tool_equipped[item] = false
	tool_data[item] = Tools.tool_templates[item_random_selection].duplicate()
	name_index += 1
	var item_panel_container = PanelContainer.new()
	var item_panel = Panel.new()
	item_panel.custom_minimum_size = Vector2(25, 25)
	var item_area = Area2D.new()
	var item_mouse_collision = CollisionShape2D.new()
	var item_collision_shape = RectangleShape2D.new()
	item_collision_shape.size = Vector2(25, 25)
	item_mouse_collision.position = Vector2(12.5, 12.5)
	item_mouse_collision.shape = item_collision_shape
	var item_rect = ColorRect.new()
	tool_data[item].rect = item_rect
	item_rect.color = tool_data[item].color
	item_rect.tooltip_text = "%s\nDurability: %d\nToughness: %d" % [
	tool_data[item].name,
	tool_data[item].Durability,
	tool_data[item].Toughness
	]
	item_rect.theme = preload("res://fonts/small_ui_element.tres")
	item_rect.size = Vector2(25, 25)
	item_area.connect("mouse_entered", Callable(self, "_on_mouse_entered").bind(item))
	item_area.connect("mouse_exited", Callable(self, "_on_mouse_exited").bind(item))
	item_area.add_child(item_rect)
	item_area.add_child(item_mouse_collision)
	item_panel.add_child(item_area)
	item_panel_container.add_child(item_panel)
	inventory_items[item] = item_panel_container
	grid_container.add_child(item_panel_container)
	save_tools()

func _spawn_rock_from_data(item_name, item_data, parent):
	mouse_hovering[item_name] = false
	tool_equipped[item_name] = false
	tool_data[item_name] = item_data

	var item_panel_container = PanelContainer.new()
	var item_panel = Panel.new()
	item_panel.custom_minimum_size = Vector2(25, 25)
	var item_area = Area2D.new()
	var item_mouse_collision = CollisionShape2D.new()
	var item_collision_shape = RectangleShape2D.new()
	item_collision_shape.size = Vector2(25, 25)
	item_mouse_collision.position = Vector2(12.5, 12.5)
	item_mouse_collision.shape = item_collision_shape
	var item_rect = ColorRect.new()
	tool_data[item_name].rect = item_rect

	# Reconstruct the color
	var color_data = item_data["color"]
	item_rect.color = Color(color_data["r"], color_data["g"], color_data["b"], color_data["a"])

	item_rect.tooltip_text = "%s\nDurability: %d\nToughness: %d" % [
	item_data.name,
	item_data.Durability,
	item_data.Toughness
	]
	item_rect.theme = preload("res://fonts/small_ui_element.tres")
	item_rect.size = Vector2(25, 25)
	item_area.connect("mouse_entered", Callable(self, "_on_mouse_entered").bind(item_name))
	item_area.connect("mouse_exited", Callable(self, "_on_mouse_exited").bind(item_name))
	item_area.add_child(item_rect)
	item_area.add_child(item_mouse_collision)
	item_panel.add_child(item_area)
	item_panel_container.add_child(item_panel)
	inventory_items[item_name] = item_panel_container

	if parent == "tool_slot":
		tool_slot.add_child(item_panel_container)
		tool_equipped[item_name] = true
		Tools.equipped_tool = tool_data[item_name]
	else:
		grid_container.add_child(item_panel_container)
		tool_equipped[item_name] = false

func save_tools():
	var saveable_tool_data = {}
	var saveable_inventory_items = {}
	var saveable_tool_equipped = {}

	for item in tool_data:
		saveable_tool_data[item] = tool_data[item].duplicate()
		# Save color as a dictionary of r, g, b, a values
		saveable_tool_data[item]["color"] = {
			"r": tool_data[item].color.r,
			"g": tool_data[item].color.g,
			"b": tool_data[item].color.b,
			"a": tool_data[item].color.a
		}
		# Remove non-serializable objects
		saveable_tool_data[item].erase("rect")

	for item in inventory_items:
		# Save the parent of the item to know its location
		saveable_inventory_items[item] = {
			"parent": "grid" if inventory_items[item].get_parent() == grid_container else "tool_slot"
		}

	saveable_tool_equipped = tool_equipped.duplicate()

	SaveSystem.set_var("tool_data", saveable_tool_data)
	SaveSystem.set_var("inventory_items", saveable_inventory_items)
	SaveSystem.set_var("tool_equipped", saveable_tool_equipped)
	SaveSystem.save()  # This writes the data to the file

func load_tools():
	var loaded_tool_data = SaveSystem.get_var("tool_data", {})
	var loaded_inventory_items = SaveSystem.get_var("inventory_items", {})
	var loaded_tool_equipped = SaveSystem.get_var("tool_equipped", {})

	# Clear existing inventory items
	for item in inventory_items:
		if inventory_items[item]:
			inventory_items[item].queue_free()
	inventory_items.clear()
	tool_data.clear()
	tool_equipped.clear()

	for item in loaded_inventory_items:
		_spawn_rock_from_data(item, loaded_tool_data[item], loaded_inventory_items[item]["parent"])
		if loaded_inventory_items[item]["parent"] == "tool_slot":
			Tools.equipped_tool = loaded_tool_data[item]
	tool_equipped = loaded_tool_equipped

var wood_tool_on_harvest_chance = 0
func _on_farm_panel_farm_tile_harvested():
	var wood_roll = randi_range(0, 100)
	wood_tool_on_harvest_chance = Upgrades.shop_items["StumpHarvest"].bought * 2
	if Stats.tools_possessed < 5:
		if wood_roll < wood_tool_on_harvest_chance:
			_spawn_rock('wood')
	pass # Replace with function body.
