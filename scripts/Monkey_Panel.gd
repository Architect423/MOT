extends PanelContainer

@onready var worker_monkey_cost_label = %worker_monkey_cost_label
@onready var worker_hire_btn = $VBoxContainer/HBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer2/worker_hire_btn
@onready var worker_monkey_qty_label = %worker_monkey_qty_label
@onready var worker_laborer_qty_label = %worker_laborer_qty_label
@onready var worker_otherproffesional_qty_label = %worker_otherproffesional_qty_label
@onready var worker_consumed_laborers_label = %worker_consumed_laborers_label
@onready var worker_consumed_proffesionals_lbl = %worker_consumed_proffesionals_lbl
@onready var worker_monkey_consumed_qty_lbl = %worker_monkey_consumed_qty_lbl
@onready var worker_increment_resource_timer = %worker_increment_resource_timer
@onready var worker_teaching_increment_timer = %worker_teaching_increment_timer
@onready var education_tiers_vbox = %education_tiers_vbox
@onready var proffessional_slots = %proffessional_slots
@onready var type_compute_timer = %type_compute_timer


var monkeys_qty = 0
var wild_qty = 0
var habituated_qty = 0
var domesticated_qty = 0
var trained_qty = 0
var educated_qty = 0
var proffesional_qty = 0
var monkey_cost = 1
var laborer_qty = 0
var consumed_laborers = 0
var consumed_proffesionals = 0

var skills = {'lumberjacks': 0, 'teachers':0}

var worker_teaching_wild_enable = false
var worker_teaching_habituated_enable = false
var worker_teaching_domesticated_enable = false
var worker_teaching_trained_enable = false
var worker_teaching_educated_enable = false
@onready var laborer_slots = %laborer_slots
var worker_qty_labels = {}
var edu_tier_qty_labels = {}
var edu_tier_teaching_btn = {}
# Called when the node enters the scene tree for the first time.
var breed_interval_timer: Timer
func _ready():
	breed_interval_timer = Timer.new()
	breed_interval_timer.one_shot = false
	breed_interval_timer.wait_time = 1
	breed_interval_timer.connect("timeout", Callable(self, "_on_breed_interval_timeout"))
	add_child(breed_interval_timer)
	breed_interval_timer.start()
	Upgrades.shop_items["Monkeys"].upgrade_target = [self]
	worker_qty_labels = {}
	for worker in Workers.worker_types:
		if Workers.worker_types[worker].type == "laborer":
			laborer_slots.add_child(_create_worker_nodes(worker))
	for worker in Workers.worker_types:
		if Workers.worker_types[worker].type == "proffessional":
			proffessional_slots.add_child(_create_worker_nodes(worker))
	edu_tier_qty_labels = {}
	edu_tier_teaching_btn = {}
	for tier in EducationTiers.tiers:
		var control_spacer = Control.new()
		control_spacer.size_flags_horizontal = Control.SIZE_EXPAND
		var control_spacer2 = Control.new()
		control_spacer2.size_flags_horizontal = Control.SIZE_EXPAND
		var hbox_edu_tier = HBoxContainer.new()
		var label_edu_tier_name = Label.new()
		label_edu_tier_name.text = EducationTiers.tiers[tier].name
		label_edu_tier_name.theme = preload("res://fonts/medium_ui_element.tres")
		var btn_down = Button.new()
		btn_down.pressed.connect(Callable(self, "_on_edu_tier_down_btn_pressed").bind(tier))
		btn_down.text = "V"
		btn_down.theme = preload("res://fonts/medium_ui_element.tres")
		var btn_max_down = Button.new()
		btn_max_down.pressed.connect(Callable(self, "_on_edu_tier_max_down_btn_pressed").bind(tier))
		btn_max_down.text = "VV"
		btn_max_down.theme = preload("res://fonts/medium_ui_element.tres")
		var label_edu_tier_qty = Label.new()
		label_edu_tier_qty.text = "0"
		label_edu_tier_qty.theme = preload("res://fonts/medium_ui_element.tres")
		edu_tier_qty_labels[tier] = label_edu_tier_qty
		var btn_up = Button.new()
		btn_up.pressed.connect(Callable(self, "_on_edu_tier_up_btn_pressed").bind(tier))
		btn_up.text = "^"
		btn_up.theme = preload("res://fonts/medium_ui_element.tres")
		var btn_max_up = Button.new()
		btn_max_up.pressed.connect(Callable(self, "_on_edu_tier_max_up_btn_pressed").bind(tier))
		btn_max_up.text = "^^"
		btn_max_up.theme = preload("res://fonts/medium_ui_element.tres")
		if EducationTiers.tiers[tier].id == 1:
			btn_up.disabled = true
			btn_max_up.disabled = true
			btn_up.modulate.a = 0
			btn_max_up.modulate.a = 0
		if EducationTiers.tiers[tier].id == 6:
			btn_down.disabled = true
			btn_max_down.disabled = true
			btn_down.modulate.a = 0
			btn_max_down.modulate.a = 0
		var label_teaching = Label.new()
		label_teaching.text = "Teaching:"
		label_teaching.theme = preload("res://fonts/medium_ui_element.tres")
		var btn_teaching = CheckButton.new()
		btn_teaching.toggled.connect(Callable(self, "_on_teaching_btn_pressed").bind(tier, btn_teaching))
		btn_teaching.disabled = true
		edu_tier_teaching_btn[tier] = btn_teaching
		hbox_edu_tier.add_child(label_edu_tier_name)
		hbox_edu_tier.add_child(control_spacer)
		hbox_edu_tier.add_child(btn_max_up)
		hbox_edu_tier.add_child(btn_up)
		hbox_edu_tier.add_child(label_edu_tier_qty)
		hbox_edu_tier.add_child(btn_down)
		hbox_edu_tier.add_child(btn_max_down)
		hbox_edu_tier.add_child(control_spacer2)
		hbox_edu_tier.add_child(label_teaching)
		hbox_edu_tier.add_child(btn_teaching)
		education_tiers_vbox.add_child(hbox_edu_tier)
		
		

func _increase_monkeycost():
	monkey_cost += 1

var breed_chance = 10
func _on_breed_interval_timeout():
	if Upgrades.shop_items["PrimitiveHuts"].bought > 0:
		breed_interval_timer.wait_time = 1 - .09 * Upgrades.shop_items["PrimitiveHuts"].bought
	if Upgrades.shop_items["Breeding"].bought == 1:
		for tier in EducationTiers.tiers:
			var tier_data = EducationTiers.tiers[tier]
			if tier_data.quantity > 100:
				var roll = randi_range(1, 100)
				if roll <= breed_chance:
					tier_data.quantity += int(tier_data.quantity / 100) * (Upgrades.shop_items["CrudeBed"].bought + 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	consumed_laborers = 0
	consumed_proffesionals = 0
	for worker in Workers.worker_types:
		if Workers.worker_types[worker].type == "laborer":
			consumed_laborers += Workers.worker_types[worker].assigned
	for worker in Workers.worker_types:
		if Workers.worker_types[worker].type == "proffessional":
			consumed_proffesionals += Workers.worker_types[worker].assigned
	_set_all_label_values()
	_prevent_overfill_laborers()
	_prevent_overfill_proffessionals()
	Workers.laborers = laborer_qty
	Workers.assigned_laborers = consumed_laborers
	Workers.proffesionals = proffesional_qty
	Workers.assigned_proffesionals = consumed_proffesionals
	if worker_increment_resource_timer.is_stopped():
		worker_increment_resource_timer.start()
	if Workers.worker_types["Teacher"].assigned > 0:
		for btn in edu_tier_teaching_btn:
			edu_tier_teaching_btn[btn].disabled = false
		if worker_teaching_increment_timer.is_stopped():
			worker_teaching_increment_timer.start()
	else:
		for btn in edu_tier_teaching_btn:
			edu_tier_teaching_btn[btn].disabled = true

func _on_teaching_btn_pressed(btn, tier, btn_teaching):
	if btn:
		EducationTiers.tiers[tier].teaching = true
	else:
		EducationTiers.tiers[tier].teaching = false
	
		
func _on_edu_tier_down_btn_pressed(tier):
	var tier_conversion_rate = EducationTiers.tiers[tier].conversion_rate
	var tier_quantity = EducationTiers.tiers[tier].quantity

	if tier_quantity >= tier_conversion_rate:
		EducationTiers.tiers[tier].quantity -= tier_conversion_rate

		var sorted_keys = EducationTiers.tiers.keys()
		var current_key_index = sorted_keys.find(tier)

		if current_key_index != -1 and current_key_index < sorted_keys.size() - 1:
			var next_key = sorted_keys[current_key_index + 1]
			EducationTiers.tiers[next_key].quantity += 1
	
func _on_edu_tier_max_down_btn_pressed(tier):
	var tier_conversion_rate = EducationTiers.tiers[tier].conversion_rate
	var tier_quantity = EducationTiers.tiers[tier].quantity
	if tier_quantity >= tier_conversion_rate:
		var possible_conversion
		# Calculate the maximum number achievable with no remainder
		possible_conversion = floor(tier_quantity/tier_conversion_rate)
		# Subtract this maximum number from wild_qty, leaving only the remainder
		EducationTiers.tiers[tier].quantity -= possible_conversion * tier_conversion_rate
		# Divide the maximum number by the conversion rate and add it to habituated_qty
		var sorted_keys = EducationTiers.tiers.keys()
		var current_key_index = sorted_keys.find(tier)

		if current_key_index != -1 and current_key_index < sorted_keys.size() - 1:
			var next_key = sorted_keys[current_key_index + 1]
			EducationTiers.tiers[next_key].quantity += possible_conversion
	
func _on_edu_tier_up_btn_pressed(tier):
	var tier_down_penalty = EducationTiers.tiers[tier].tier_down_penalty
	var tier_quantity = EducationTiers.tiers[tier].quantity
	var sorted_keys = EducationTiers.tiers.keys()
	var current_key_index = sorted_keys.find(tier)
	var prev_tier_conversion_rate
	var prev_key
	if current_key_index > 0:
		prev_key = sorted_keys[current_key_index - 1]
		prev_tier_conversion_rate = EducationTiers.tiers[prev_key].conversion_rate
	if  tier_quantity > 0:
		EducationTiers.tiers[prev_key].quantity += floor(prev_tier_conversion_rate*tier_down_penalty)
		EducationTiers.tiers[tier].quantity -= 1

func _on_edu_tier_max_up_btn_pressed(tier):
	var tier_down_penalty = EducationTiers.tiers[tier].tier_down_penalty
	var tier_quantity = EducationTiers.tiers[tier].quantity
	var sorted_keys = EducationTiers.tiers.keys()
	var current_key_index = sorted_keys.find(tier)
	var prev_tier_conversion_rate
	var prev_key
	if current_key_index > 0:
		prev_key = sorted_keys[current_key_index - 1]
		prev_tier_conversion_rate = EducationTiers.tiers[prev_key].conversion_rate
	if  tier_quantity > 0:
		EducationTiers.tiers[prev_key].quantity += floor(prev_tier_conversion_rate*tier_down_penalty) * tier_quantity
		EducationTiers.tiers[tier].quantity = 0

func _on_worker_zero_btn_pressed(worker):
	if Workers.worker_types[worker].type == "laborer":
		if Workers.worker_types[worker].assigned > 0:
			Workers.worker_types[worker].assigned = 0
	elif Workers.worker_types[worker].type == "proffessional":
		if Workers.worker_types[worker].assigned > 0:
			Workers.worker_types[worker].assigned = 0

func _on_worker_minus_btn_pressed(worker):
	if Workers.worker_types[worker].type == "laborer":
		if Workers.worker_types[worker].assigned > 0:
			Workers.worker_types[worker].assigned -= 1
	elif Workers.worker_types[worker].type == "proffessional":
		if Workers.worker_types[worker].assigned > 0:
			Workers.worker_types[worker].assigned -= 1

func _on_worker_max_btn_pressed(worker):
	if Workers.worker_types[worker].type == "laborer":
		if consumed_laborers < laborer_qty:
			Workers.worker_types[worker].assigned += laborer_qty - consumed_laborers
	elif Workers.worker_types[worker].type == "proffessional":
		if consumed_proffesionals < proffesional_qty:
			Workers.worker_types[worker].assigned += proffesional_qty - consumed_proffesionals
		
func _on_worker_plus_btn_pressed(worker):
	if Workers.worker_types[worker].type == "laborer":
		if consumed_laborers < laborer_qty:
			Workers.worker_types[worker].assigned += 1
	elif Workers.worker_types[worker].type == "proffessional":
		if consumed_proffesionals < proffesional_qty:
			Workers.worker_types[worker].assigned += 1
		
func _on_worker_increment_resource_timer_timeout():
	Increments.increment_resource("wood", Workers.worker_types["Lumberjack"].assigned)
	Increments.increment_resource("scratches", Workers.worker_types["Scratcher"].assigned)
	pass # Replace with function body.

func _on_worker_teaching_increment_timer_timeout():
	for tier in EducationTiers.tiers:
		if EducationTiers.tiers[tier].teaching:
			_on_edu_tier_down_btn_pressed(tier)

func _on_worker_hire_btn_pressed():
	if Resources.bananas >= monkey_cost:
		Resources.bananas -= monkey_cost
		EducationTiers.tiers["Tier1"].quantity += 1
		monkey_cost += 1

#Sometimes during transmutation the max laborer quantity will be exceeded. This corrects it
func _prevent_overfill_laborers():
	if consumed_laborers > laborer_qty:
		for worker in Workers.worker_types:
			if Workers.worker_types[worker].type == "laborer":
				if Workers.worker_types[worker].assigned > 0:
					if (consumed_laborers - Workers.worker_types[worker].assigned) <= laborer_qty:
						Workers.worker_types[worker].assigned -= consumed_laborers - laborer_qty
					else:
						Workers.worker_types[worker].assigned = 0

#Sometimes during transmutation the max laborer quantity will be exceeded. This corrects it
func _prevent_overfill_proffessionals():
	if consumed_proffesionals > proffesional_qty:
		for worker in Workers.worker_types:
			if Workers.worker_types[worker].type == "proffessional":
				if Workers.worker_types[worker].assigned > 0:
					if (consumed_proffesionals - Workers.worker_types[worker].assigned) <= proffesional_qty:
						Workers.worker_types[worker].assigned -= consumed_proffesionals - proffesional_qty
					else:
						Workers.worker_types[worker].assigned = 0
						
func _set_all_label_values():
	for worker in Workers.worker_types:
		worker_qty_labels[worker].text = str(Workers.worker_types[worker].assigned)
	monkeys_qty = 0
	for tier in EducationTiers.tiers:
		edu_tier_qty_labels[tier].text = str(EducationTiers.tiers[tier].quantity)
		monkeys_qty += EducationTiers.tiers[tier].quantity
	worker_monkey_cost_label.text = str(monkey_cost)
	worker_monkey_qty_label.text = str(monkeys_qty)
	laborer_qty = EducationTiers.tiers["Tier4"].quantity + EducationTiers.tiers["Tier5"].quantity
	proffesional_qty = EducationTiers.tiers["Tier6"].quantity
	worker_laborer_qty_label.text = str(laborer_qty)
	worker_otherproffesional_qty_label.text = str(proffesional_qty)
	worker_consumed_laborers_label.text = str(consumed_laborers)
	worker_consumed_proffesionals_lbl.text = str(consumed_proffesionals)
	worker_monkey_consumed_qty_lbl.text = str(consumed_laborers+consumed_proffesionals)
	
func _create_worker_nodes(worker):
	var control_spacer = Control.new()
	control_spacer.size_flags_horizontal = Control.SIZE_EXPAND
	var hbox_laborer_type = HBoxContainer.new()
	var label_laborer_name = Label.new()
	label_laborer_name.text = Workers.worker_types[worker].name
	var btn_zero = Button.new()
	btn_zero.text = "<<"
	btn_zero.theme = preload("res://fonts/small_ui_element.tres")
	btn_zero.pressed.connect(Callable(self, "_on_worker_zero_btn_pressed").bind(worker))
	var btn_minus = Button.new()
	btn_minus.text = "<"
	btn_minus.theme = preload("res://fonts/small_ui_element.tres")
	btn_minus.pressed.connect(Callable(self, "_on_worker_minus_btn_pressed").bind(worker))
	var label_laborer_qty = Label.new()
	label_laborer_qty.text = "0"
	label_laborer_qty.theme = preload("res://fonts/small_ui_element.tres")
	worker_qty_labels[worker] = label_laborer_qty
	var btn_plus = Button.new()
	btn_plus.text = ">"
	btn_plus.theme = preload("res://fonts/small_ui_element.tres")
	btn_plus.pressed.connect(Callable(self, "_on_worker_plus_btn_pressed").bind(worker))
	var btn_max = Button.new()
	btn_max.text = ">>"
	btn_max.theme = preload("res://fonts/small_ui_element.tres")
	btn_max.pressed.connect(Callable(self, "_on_worker_max_btn_pressed").bind(worker))
	hbox_laborer_type.add_child(label_laborer_name)
	hbox_laborer_type.add_child(control_spacer)
	hbox_laborer_type.add_child(btn_zero)
	hbox_laborer_type.add_child(btn_minus)
	hbox_laborer_type.add_child(label_laborer_qty)
	hbox_laborer_type.add_child(btn_plus)
	hbox_laborer_type.add_child(btn_max)
#	if Workers.worker_types[worker].name == "Typist":
#		hbox_laborer_type.visible = false
	return hbox_laborer_type
	


func _on_type_compute_timer_timeout():
	if Workers.worker_types["Typist"].assigned > 0:
		var typist_increment = 0
		if Workers.worker_types["Typist"].assigned >= Library.typewriters:
			typist_increment = Library.typewriters
		else:
			typist_increment = Workers.worker_types["Typist"].assigned
		Increments.increment_resource("letters", typist_increment)
	if Workers.worker_types["Editor"].assigned > 0:
		var editor_increment = 0
		if Workers.worker_types["Editor"].assigned >= Library.computers:
			editor_increment = Library.computers
		else:
			editor_increment = Workers.worker_types["Editor"].assigned
		if Resources.letters >= 10 * editor_increment:
			Resources.letters -= 10 * editor_increment
			Increments.increment_resource("words", editor_increment)

var base_chiseler_time = 10
@onready var chiseler_timer = %chiseler_timer
signal chiseler
func _on_chiseler_timer_timeout():
	chiseler_timer.wait_time = base_chiseler_time * pow (.98, Workers.worker_types["Chiseler"].assigned) 
	if Workers.worker_types["Chiseler"].assigned > 0:
		chiseler.emit()
