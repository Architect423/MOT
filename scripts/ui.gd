extends Control

@onready var resource_scratches_qty_label = %resource_scratches_qty_label
@onready var resource_bananas_qty_label = %resource_bananas_qty_label
@onready var resource_coal_qty_label = %resource_coal_qty_label
@onready var mouse_pos = $mouse_pos
@onready var resource_wood_qty_label = %resource_wood_qty_label
@onready var resource_pelt_qty_label = %resource_pelt_qty_label
@onready var resource_gems_qty_label = %resource_gems_qty_label
@onready var resource_1 = %Resource_1
@onready var resource_2 = %Resource_2
@onready var resource_3 = %Resource_3
@onready var resource_4 = %Resource_4
@onready var resource_5 = %Resource_5
@onready var resource_6 = %Resource_6
@onready var resource_letters_qty_label = %resource_letters_qty_label
@onready var resource_words_qty_label = %resource_words_qty_label

@onready var game_manager = get_node("/root/GameManager")

func _ready():
	resource_1.modulate.a = 0
	resource_2.modulate.a = 0
	resource_3.modulate.a = 0
	resource_4.modulate.a = 0
	resource_5.modulate.a = 0
	resource_6.modulate.a = 0
	resource_letters_qty_label.modulate.a = 0
	resource_words_qty_label.modulate.a = 0
	Library.load_library()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Resources.scratches > 0:
		resource_1.modulate.a = 1
	if Resources.bananas > 0:
		resource_2.modulate.a = 1
	if Resources.coal > 0:
		resource_3.modulate.a = 1
	if Resources.wood > 0:
		resource_4.modulate.a = 1
	if Resources.pelts > 0:
		resource_5.modulate.a = 1
	if Resources.gems > 0:
		resource_6.modulate.a = 1
	if Resources.letters > 0:
		resource_letters_qty_label.modulate.a = 1
	if Resources.words > 0:
		resource_words_qty_label.modulate.a = 1
		
		
	resource_bananas_qty_label.text = str(int(Resources.bananas))
	resource_scratches_qty_label.text = str(int(Resources.scratches))
	resource_wood_qty_label.text = str(int(Resources.wood))
	resource_coal_qty_label.text = str(int(Resources.coal))
	resource_pelt_qty_label.text = str(int(Resources.pelts))
	resource_letters_qty_label.text = str(int(Resources.letters))
	resource_words_qty_label.text = str(int(Resources.words))
	mouse_pos.text = str(get_viewport().get_mouse_position())
	resource_gems_qty_label.text = str(int(Resources.gems))
	var resource_name = "scratches"  # Example resource
	var base_value = 1.0  # Example base value
	var current_value = game_manager.calculate_resource_gain(resource_name, base_value)
#	resource_display.text = "{resource}: {value}".format({
#		"resource": resource_name.capitalize(),
#		"value": current_value
#	})
	resource_scratches_qty_label.tooltip_text = game_manager.format_resource_stats(resource_name, base_value)
	



func _on_autosave_timeout():
	Resources.save_resources()
	Upgrades.save_upgrades()
	EducationTiers.save_education_tiers()
	Workers.save_workers()
	Discoveries.save_discoveries()
	Library.save_library()
	Stats.save_stats()
