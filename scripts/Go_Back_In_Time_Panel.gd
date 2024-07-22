extends PanelContainer

@onready var discoveries_grid = %discoveries_grid
@onready var discoveries_slots = %discoveries_slots
@onready var confirm_prestige_btn = %confirm_prestige_btn

var toggled_buttons = []
var slot_labels = []
var slot_descriptions = []

func _ready():
	populate_discovery_tiles()
	populate_discovery_slots()
	update_discovery_slots()  # Call this to initialize slot colors
	confirm_prestige_btn.connect("pressed", Callable(self, "_on_confirm_prestige"))

func populate_discovery_tiles():
	for letter in Discoveries.letters:
		var letter_data = Discoveries.letters[letter]
		var letter_btn = Button.new()
		letter_btn.toggle_mode = true
		letter_btn.text = letter_data.name
		letter_btn.connect("toggled", Callable(self, "_on_letter_button_toggled").bind(letter_btn, letter_data))
		discoveries_grid.add_child(letter_btn)

func populate_discovery_slots():
	for i in range(Prestige.discovery_slots):
		var slot = PanelContainer.new()
		slot.custom_minimum_size = Vector2(90, 90)
		slot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		
		var slot_vbox = VBoxContainer.new()
		
		var letter_panel = PanelContainer.new()
		letter_panel.custom_minimum_size = Vector2(20, 20)
		letter_panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		letter_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		
		var label = Label.new()
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.theme = preload("res://fonts/medium_ui_element.tres")
		
		var description_label = RichTextLabel.new()
		description_label.fit_content = true
		description_label.text = ""
		description_label.theme = preload("res://fonts/small_ui_element.tres")
		
		letter_panel.add_child(label)
		slot_vbox.add_child(letter_panel)
		slot_vbox.add_child(description_label)
		slot.add_child(slot_vbox)
		discoveries_slots.add_child(slot)
		
		slot_labels.append(label)
		slot_descriptions.append(description_label)

func _on_letter_button_toggled(button_pressed: bool, letter_btn: Button, letter_data: Dictionary):
	if button_pressed:
		if len(toggled_buttons) >= Prestige.discovery_slots:
			var button_to_untoggle = toggled_buttons.pop_front()
			button_to_untoggle.set_pressed_no_signal(false)    
		toggled_buttons.append(letter_btn)
	else:
		toggled_buttons.erase(letter_btn)
	update_discovery_slots()

func update_discovery_slots():
	for i in range(slot_labels.size()):
		var slot = discoveries_slots.get_child(i)
		if i < toggled_buttons.size():
			var letter_data = Discoveries.letters[toggled_buttons[i].text]
			slot_labels[i].text = letter_data.name
			slot_descriptions[i].text = letter_data.prestige_effect_desc
			slot.modulate = Color.WHITE
		else:
			slot_labels[i].text = ""
			slot_descriptions[i].text = ""
			slot.modulate = Color(0.5, 0.5, 0.5)  # Gray out empty slots

func _on_confirm_prestige_btn_pressed():
	for button in toggled_buttons:
		var letter = button.text
		Discoveries.letters[letter].activated = true	
	# Here you might want to add additional logic for what happens after confirming prestige
	SaveSystem.delete("resources")
	SaveSystem.delete("upgrades")
	SaveSystem.delete("worker_types")
	SaveSystem.delete("education_tiers")
	SaveSystem.delete("tool_data")
	SaveSystem.delete("inventory_items")
	SaveSystem.delete("tool_equipped")
	SaveSystem.delete("stats")
	_on_close_button_pressed()
	Resources.load_resources()
	Upgrades.load_upgrades()
	EducationTiers.load_education_tiers()
	Workers.load_workers_types()
	Stats.load_stats()
	get_tree().reload_current_scene()
	print("Prestige confirmed, activated letters updated")
	# You might want to reset the UI or perform other actions here
	pass # Replace with function body.


func _on_close_button_pressed():
	var popup = find_parent("prestige_popup")
	popup.visible = false
	pass # Replace with function body.
