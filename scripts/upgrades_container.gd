extends VBoxContainer

# Called when the node enters the scene tree for the first time.

@onready var vbox_container = find_child("VboxContainer")
var bought_qty_labels = {}
func _ready():
	game_manager = get_node("/root/GameManager")
var multipliers = {}
var adders = {}
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	multipliers = {}
	
	for item_key in Upgrades.shop_items:
		var item_data = Upgrades.shop_items[item_key]
		for panel_container in vbox_container.get_children():
			if panel_container.name == item_data.name:
				for margin_container in panel_container.get_children():
					for item_hbox in margin_container.get_children():
						for button_vbox in item_hbox.get_children():
							for child in button_vbox.get_children():
								if child is Label and child.name == "cost_label":
									child.text = "Cost: " + str(int(item_data.cost)) + " " + item_data.units
		if bought_qty_labels.has(item_key):
			bought_qty_labels[item_key].text = str(item_data.bought) + "/" + str(item_data.max_qty)
		if Resources.get(item_data.unlock_currency) > item_data.unlock_cost:
			if item_data.has("prerequisites"):
				var check_prereqs = 0
				for prerequisite in item_data.prerequisites:
					if Upgrades.shop_items[prerequisite].bought == 0:
						check_prereqs += 1
				if check_prereqs == 0:
					Upgrades.shop_items[item_key].unlocked = true
			else:
				Upgrades.shop_items[item_key].unlocked = true
		if item_data.has('upgrade_type'):
			if item_data.upgrade_type == "SimpleVisibility":
				if item_data.bought >= 1:
					Increments.visibility(item_data.upgrade_target)
				else:
					Increments.invisibility(item_data.upgrade_target)
						

		if item_data.grid == get_meta("grid"):
			if item_data.unlocked:
				if not item_data.visible:
					if item_data.bought < item_data.max_qty:
						var margin_container = MarginContainer.new()
						margin_container.add_theme_constant_override("margin_left", 10)
						margin_container.add_theme_constant_override("margin_right", 10)
						margin_container.add_theme_constant_override("margin_top", 10)
						margin_container.add_theme_constant_override("margin_bottom", 10)
						# Create a PanelContainer instance
						var panel_container = PanelContainer.new()
						panel_container.name = item_data.name
						# Create an HBoxContainer as the child of the PanelContainer
						var item_hbox = HBoxContainer.new()
						margin_container.add_child(item_hbox)

						# Create a VBoxContainer for the item name and label
						var label_vbox = VBoxContainer.new()
						item_hbox.add_child(label_vbox)

						# Create a Label for the item name
						var name_label = Label.new()
						name_label.text = item_data.name
						var name_label_theme = load("res://fonts/upgrade_name_label_theme.tres")
						name_label.theme = name_label_theme
						label_vbox.add_child(name_label)
						var desc_qty_hbox = HBoxContainer.new()
						# Create a Label for the item label
						var label_label = RichTextLabel.new()
						label_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
						label_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
						label_label.text = item_data.label
						label_label.fit_content = true  # Automatically fits text content
						label_label.custom_minimum_size = Vector2(150, 30)  # Adjust as needed
						var desc_label_theme = load("res://fonts/upgrade_desc_label_theme.tres")
						label_label.theme = desc_label_theme
						desc_qty_hbox.add_child(label_label)
						var qty_label = Label.new()
						qty_label.text = str(item_data.bought) + "/" + str(item_data.max_qty)
						bought_qty_labels[item_key] = qty_label
						qty_label.theme = name_label_theme
						desc_qty_hbox.add_child(qty_label)
						label_vbox.add_child(desc_qty_hbox)
						# Create a blank control node to space the text and purchase button
						var spacer_box = Control.new()
						spacer_box.size_flags_horizontal = 2
						item_hbox.add_child(spacer_box)
						# Create an HBoxContainer for the purchase button
						var button_vbox = VBoxContainer.new()
						button_vbox.alignment = BoxContainer.ALIGNMENT_END
						item_hbox.add_child(button_vbox)

						# Create a Button for purchasing the item
						var purchase_button = Button.new()
						purchase_button.text = "Buy"
						purchase_button.theme = preload("res://fonts/upgrade_buy_label_theme.tres")
						button_vbox.add_child(purchase_button)
						
						# Create a Label for the item label
						var cost_label = Label.new()
						cost_label.name = "cost_label"
						cost_label.text = "Cost: " + str(item_data.cost) + " " + item_data.units
						cost_label.theme = preload("res://fonts/upgrade_cost_label_theme.tres")
						button_vbox.add_child(cost_label)
						
						# Connect the purchase button signal
						# Connect the purchase button signal
						purchase_button.connect("pressed", Callable(self, "_on_purchase_button_pressed").bind(item_key))
						panel_container.add_child(margin_container)
						# Add the PanelContainer to the VBoxContainer
						vbox_container.add_child(panel_container)
						Upgrades.shop_items[item_key].visible = true
		
signal item_purchased
var game_manager: GameManager
func _on_purchase_button_pressed(item_key):
	# Handle the purchase logic for the clicked item
	var item_data = Upgrades.shop_items[item_key]
	
	var item_currency_value = Resources.get(item_data.units)
	if item_currency_value >= item_data.cost:
		if item_data.bought < item_data.max_qty:
			var remaining_balance = item_currency_value - item_data.cost
			Resources.set(item_data.units, remaining_balance)
			Upgrades.shop_items[item_key].bought += 1
			if "upgrade_type" in item_data and "upgrade_value" in item_data and "upgrade_target" in item_data:
				game_manager.apply_upgrade(
					item_data.upgrade_target, 
					item_data.upgrade_type, 
					item_data.upgrade_value, 
					item_data.bought,
					item_data.name  # Pass the total quantity bought
				)
			if item_data.has("custom_cost_scale"):
				Upgrades.shop_items[item_key].cost = item_data.custom_cost_scale[item_data.bought]
			else:
				Upgrades.shop_items[item_key].cost = Upgrades.shop_items[item_key].cost * pow(1.1,Upgrades.shop_items[item_key].bought)
			item_purchased.emit(item_data)
	if item_data.bought == item_data.max_qty:
		for child in vbox_container.get_children():
			if child.name == item_data.name:
				bought_qty_labels.erase(item_key)
				child.queue_free()
		
