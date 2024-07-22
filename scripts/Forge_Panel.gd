extends PanelContainer

@onready var forge_stoke_progress = %forge_stoke_progress
@onready var forge_stoke_button = %forge_stoke_button
@onready var forge_fuel_progress = %forge_fuel_progress
@onready var burn_tick_timer = %burn_tick_timer
@onready var stoke_decay_tick_timer = %stoke_decay_tick_timer
@onready var infra_main_vbox = %infra_main_vbox
@onready var fuel_container = %fuel_container
@onready var infrastructure_tick_timer = %infrastructure_tick_timer

var fuel = 0
var stoke = 0
var base_max_stoke = 100
var max_stoke = 100
var max_fuel = 100
var base_max_fuel = 100
var stoke_decay = .1
var manual_stoke = 10

var fuel_items = {
	"Coal": {
		"name": "coal",
		"fuel_value": 5,
		"base_fuel_value": 5,
		"qty": Resources.coal,
		"id": 1
	},
	
	"Wood": {
		"name": "wood",
		"fuel_value": 2,
		"base_fuel_value": 2,
		"qty": Resources.wood,
		"id": 2
	},
}
# Called when the node enters the scene tree for the first time.
var fuel_progress_text_label
var stoke_progress_text_label
func _ready():
	Upgrades.shop_items["Furnace"].upgrade_target = [self]
	instantiate_fuel_types()
	_instantiate_infrastructure()
	fuel_progress_text_label = Label.new()
	fuel_progress_text_label.text = "0/100"
	fuel_progress_text_label.theme = preload("res://fonts/medium_ui_element.tres")
	fuel_progress_text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	fuel_progress_text_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	fuel_progress_text_label.layout_mode = 1
	fuel_progress_text_label.anchors_preset = PRESET_VCENTER_WIDE
	forge_fuel_progress.add_child(fuel_progress_text_label)
	
	stoke_progress_text_label = Label.new()
	stoke_progress_text_label.text = "0/100"
	stoke_progress_text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stoke_progress_text_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	stoke_progress_text_label.theme = preload("res://fonts/medium_ui_element.tres")
	stoke_progress_text_label.layout_mode = 1
	stoke_progress_text_label.anchors_preset = PRESET_VCENTER_WIDE
	forge_stoke_progress.add_child(stoke_progress_text_label)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fuel_progress_text_label.text = str(ceil(fuel)) + "/" + str(max_fuel)
	stoke_progress_text_label.text = str(ceil(stoke)) + "/" + str(max_stoke)
	stoke_decay = lerp(.1, 3.0, float(stoke/max_stoke))
	max_stoke = base_max_stoke + 50 * Upgrades.shop_items["BrickExtensions"].bought
	forge_stoke_progress.value = stoke
	forge_fuel_progress.value = fuel
	forge_stoke_progress.max_value = max_stoke
	forge_fuel_progress.max_value = max_fuel
	_forge_stoke_decay()
	if fuel > 0:
		_burn()
	_infra_burn()
	if Upgrades.shop_items["Blower"].bought > 0:
		manual_stoke = 1.5 * Upgrades.shop_items["Blower"].bought
	if Upgrades.shop_items["CombustionVessel"].bought > 0:
		max_fuel = 100 + 100 * Upgrades.shop_items["CombustionVessel"].bought

func _on_forge_stoke_button_pressed():
	if stoke + manual_stoke <= max_stoke:
		stoke += manual_stoke

func _forge_stoke_decay():
	if stoke_decay_tick_timer.is_stopped():
		if stoke > 0:
			var insulation_level = Upgrades.shop_items["Insulation"].bought
			stoke -= (stoke_decay * (pow(.9, insulation_level) + 1))
			stoke_decay_tick_timer.start()

func _burn():
	if burn_tick_timer.is_stopped():
		if stoke + 10 <= max_stoke:
			burn_tick_timer.start()
			fuel -= 1
			stoke += 10

func _infra_burn():
	if infrastructure_tick_timer.is_stopped():
		infrastructure_tick_timer.start()
		for infra_item in Infrastructure.infra_items:
			if Infrastructure.infra_items[infra_item].enabled:
				if stoke >= Infrastructure.infra_items[infra_item].cost:
					if not Infrastructure.infra_items[infra_item].active:
						stoke -= Infrastructure.infra_items[infra_item].cost
						Infrastructure.infra_items[infra_item].active = true
						#GlobalMultipliers.global_multiplier += 1
				else:
					if Infrastructure.infra_items[infra_item].active:
						Infrastructure.infra_items[infra_item].active = false
						var infra_btn = Infrastructure.infra_items[infra_item].btn
						infra_btn.button_pressed = false
						#GlobalMultipliers.global_multiplier -= 1
			if Infrastructure.infra_items[infra_item].active:
				stoke -= Infrastructure.infra_items[infra_item].cost

func _on_infra_btn_pressed(btn, infra_item, infra_check):
	if btn:
		Infrastructure.infra_items[infra_item].enabled = true	
	else:
		Infrastructure.infra_items[infra_item].enabled = false
		
var infra_buttons = {}
func _on_infra_dropdown(infra_dropdown_btn, infra_desc_label, infra_cost_label):
	if infra_dropdown_btn.text == ">":
		infra_desc_label.visible = true
		infra_cost_label.visible = true
		infra_dropdown_btn.text = "V"
	elif infra_dropdown_btn.text == "V":
		infra_desc_label.visible = false
		infra_cost_label.visible = false
		infra_dropdown_btn.text = ">"
		
	
func _instantiate_infrastructure():
	for infra_item in Infrastructure.infra_items:
		var infra_panel = PanelContainer.new()
		var infra_margin = MarginContainer.new()
		var infra_instance_vbox = VBoxContainer.new()
		var infra_hbox = HBoxContainer.new()
		var infra_info_vbox = VBoxContainer.new()
		var infra_name_label = Label.new()
		var infra_desc_label = RichTextLabel.new()
		infra_desc_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		infra_desc_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
		infra_desc_label.fit_content = true  # Automatically fits text content
		infra_desc_label.custom_minimum_size = Vector2(200, 30)  # Adjust as needed
		var infra_enb_vbox = VBoxContainer.new()
		var infra_check = CheckButton.new()
		Infrastructure.infra_items[infra_item].btn = infra_check
		var infra_cost_label = Label.new()
		var infra_dropdown_btn = Button.new()
		var infra_header_hbox = HBoxContainer.new()
		infra_dropdown_btn.text = "V"
		infra_dropdown_btn.pressed.connect(Callable(self, "_on_infra_dropdown").bind(infra_dropdown_btn, infra_desc_label, infra_cost_label))
		infra_check.toggled.connect(Callable(self, "_on_infra_btn_pressed").bind(infra_item, infra_check))
		infra_check.size_flags_horizontal = Control.SIZE_SHRINK_END
		infra_enb_vbox.add_child(infra_check)
		infra_cost_label.theme = preload("res://fonts/upgrade_cost_label_theme.tres")
		infra_cost_label.text = "-" + str(Infrastructure.infra_items[infra_item].cost) + " stoke"
		infra_enb_vbox.add_child(infra_cost_label)
		infra_name_label.theme = preload("res://fonts/upgrade_name_label_theme.tres")
		infra_name_label.text = Infrastructure.infra_items[infra_item].name
		infra_header_hbox.add_child(infra_dropdown_btn)
		infra_header_hbox.add_child(infra_name_label)
		infra_info_vbox.add_child(infra_header_hbox)
		infra_desc_label.theme = preload("res://fonts/upgrade_desc_label_theme.tres")
		infra_desc_label.text = Infrastructure.infra_items[infra_item].desc
		infra_info_vbox.add_child(infra_desc_label)
		infra_hbox.add_child(infra_info_vbox)
		var infra_spacer = Control.new()
		infra_spacer.size_flags_horizontal = Control.SIZE_EXPAND
		infra_hbox.add_child(infra_spacer)
		infra_hbox.add_child(infra_enb_vbox)
		infra_instance_vbox.add_child(infra_hbox)
		infra_margin.add_theme_constant_override("margin_left", 10)
		infra_margin.add_theme_constant_override("margin_right", 10)
		infra_margin.add_theme_constant_override("margin_top", 10)
		infra_margin.add_theme_constant_override("margin_bottom", 10)
		infra_margin.add_child(infra_instance_vbox)
		infra_panel.add_child(infra_margin)
		infra_main_vbox.add_child(infra_panel)
		infra_panel.custom_minimum_size = infra_panel.size
		infra_panel.custom_minimum_size.y = 0

func instantiate_fuel_types():
	for fuel_type in fuel_items:
		var fuel_hbox = HBoxContainer.new()
		var fuel_name_lbl = Label.new()
		fuel_name_lbl.text = fuel_type
		fuel_name_lbl.theme = preload("res://fonts/large_ui_element.tres")
		fuel_hbox.add_child(fuel_name_lbl)
		var fuel_spacer = Control.new()
		fuel_spacer.size_flags_horizontal = Control.SIZE_EXPAND
		fuel_hbox.add_child(fuel_spacer)
		var fuel_btn_1 = Button.new()
		fuel_btn_1.text = "1"
		fuel_btn_1.theme = preload("res://fonts/medium_ui_element.tres")
		fuel_btn_1.pressed.connect(Callable(self, "_on_fuel_1_btn_pressed").bind(fuel_type))
		var fuel_btn_10pct = Button.new()
		fuel_btn_10pct.text = "10%"
		fuel_btn_10pct.theme = preload("res://fonts/medium_ui_element.tres")
		fuel_btn_10pct.pressed.connect(Callable(self, "_on_fuel_10pct_btn_pressed").bind(fuel_type))
		var fuel_btn_50pct = Button.new()
		fuel_btn_50pct.text = "50%"
		fuel_btn_50pct.theme = preload("res://fonts/medium_ui_element.tres")
		fuel_btn_50pct.pressed.connect(Callable(self, "_on_fuel_50pct_btn_pressed").bind(fuel_type))
		var fuel_btn_max = Button.new()
		fuel_btn_max.text = "Max"
		fuel_btn_max.theme = preload("res://fonts/medium_ui_element.tres")
		fuel_btn_max.pressed.connect(Callable(self, "_on_fuel_max_btn_pressed").bind(fuel_type))
		fuel_hbox.add_child(fuel_btn_1)
		fuel_hbox.add_child(fuel_btn_10pct)
		fuel_hbox.add_child(fuel_btn_50pct)
		fuel_hbox.add_child(fuel_btn_max)
		fuel_container.add_child(fuel_hbox)

func _on_fuel_1_btn_pressed(fuel_type):
	var fuel_data = fuel_items[fuel_type]
	var fuel_name = fuel_data.name
	fuel_data.qty = Resources.get(fuel_data.name)
	if Resources.get(fuel_data.name) > 0:
		if fuel < max_fuel:
			fuel += fuel_data.fuel_value
			Resources.set(fuel_data.name, Resources.get(fuel_data.name) - 1)
			
func _on_fuel_10pct_btn_pressed(fuel_type):
	var fuel_data = fuel_items[fuel_type]
	fuel_data.qty = Resources.get(fuel_data.name)
	if fuel_data.qty >= 10:
		if fuel < max_fuel:
			var fuel_to_use = ceil(fuel_data.qty * 0.10)
			var fuel_to_fill = ceil((max_fuel - fuel) / fuel_data.fuel_value)
			if fuel_to_use > fuel_to_fill:
				fuel += fuel_to_fill * fuel_data.fuel_value
				Resources.set(fuel_data.name, fuel_data.qty - fuel_to_fill)
			else:
				fuel += fuel_to_use * fuel_data.fuel_value
				Resources.set(fuel_data.name, fuel_data.qty - fuel_to_use)
			
func _on_fuel_50pct_btn_pressed(fuel_type):
	var fuel_data = fuel_items[fuel_type]
	fuel_data.qty = Resources.get(fuel_data.name)
	if fuel_data.qty >= 2:
		if fuel < max_fuel:
			var fuel_to_use = ceil(fuel_data.qty * 0.50)
			var fuel_to_fill = ceil((max_fuel - fuel) / fuel_data.fuel_value)
			if fuel_to_use > fuel_to_fill:
				fuel += fuel_to_fill * fuel_data.fuel_value
				Resources.set(fuel_data.name, fuel_data.qty - fuel_to_fill)
			else:
				fuel += fuel_to_use * fuel_data.fuel_value
				Resources.set(fuel_data.name, fuel_data.qty - fuel_to_use)
			
func _on_fuel_max_btn_pressed(fuel_type):
	var fuel_data = fuel_items[fuel_type]
	fuel_data.qty = Resources.get(fuel_data.name)
	if fuel_data.qty > 0:
		if fuel < max_fuel:
			var fuel_to_use = ceil(fuel_data.qty * 1)
			var fuel_to_fill = ceil((max_fuel - fuel) / fuel_data.fuel_value)
			if fuel_to_use > fuel_to_fill:
				fuel += fuel_to_fill * fuel_data.fuel_value
				Resources.set(fuel_data.name, fuel_data.qty - fuel_to_fill)
			else:
				fuel += fuel_to_use * fuel_data.fuel_value
				Resources.set(fuel_data.name, fuel_data.qty - fuel_to_use)
		
	
