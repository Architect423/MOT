extends PanelContainer

@onready var letter_grid = %LetterGrid
@onready var mouse_marker = %Mouse_marker
@onready var prestige_button = %prestige_button

var min_id = 0
var max_id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	prestige_button.modulate.a = 0
	self.modulate.a = 0
#	Upgrades.shop_items["Discovery"].upgrade_target = [self]
	_calc_discoverable_difficulty()
	#load_discoveries()
	for letter in Discoveries.letters:
		var letter_data = Discoveries.letters[letter]
		var tile_2d = Area2D.new()
		var tile_collision = CollisionShape2D.new()
		tile_collision.shape = RectangleShape2D.new()
		tile_collision.z_index = 7
		tile_2d.add_child(tile_collision)
		if letter_data.segments >= Resources.segments:
			Discoveries.letters[letter].discoverable = true
		_calc_letter_discovery_bounds(letter_data)
		var letter_panel = PanelContainer.new()
		letter_panel.add_to_group('letter_panel')
		letter_panel.add_child(tile_2d)
		letter_panel.name = str(letter_data.id)
		var letter_label = Label.new()
		var letter_margin = MarginContainer.new()
		letter_label.text = letter_data.label
		letter_label.theme = preload("res://fonts/extra_large_ui_element.tres")
		letter_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		letter_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		letter_label.name = letter_data.name
		letter_label.add_to_group('letter_text')
		var margin_value = 10
		letter_margin.add_theme_constant_override("margin_top", margin_value)
		letter_margin.add_theme_constant_override("margin_left", margin_value)
		letter_margin.add_theme_constant_override("margin_bottom", margin_value)
		letter_margin.add_theme_constant_override("margin_right", margin_value)
		letter_margin.add_child(letter_label)
		letter_panel.add_child(letter_margin)
		letter_grid.add_child(letter_panel)
	_update_letter_visuals()
			
var previous_scratches = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
var discovery_counter = 0

var discoveries_made = 0
func _process(delta):
	var current_scratches = Resources.scratches
	var scratch_delta = current_scratches - previous_scratches
	var dice_roll
	if scratch_delta > 0:
		discovery_counter += scratch_delta
		#save_discoveries()
	previous_scratches = Resources.scratches
	if discoveries_made > 3:
		prestige_button.modulate.a = 1
	for letter in Discoveries.letters:
		var letter_data = Discoveries.letters[letter]
		if discovery_counter >= letter_data.chance && not letter_data.discovered:
			discovery_counter = 0
			letter_data.discovered = true
			discoveries_made += 1
			self.modulate.a = 1
			#save_discoveries()
		if letter_data.discovered:
			for node in get_tree().get_nodes_in_group("letter_text"):
				if node.name == letter_data.name:
					node.add_theme_color_override("font_color", Color.GREEN)
				
func _calc_letter_discovery_bounds(letter_data):
	if letter_data.id <= min_id:
		min_id = letter_data.id
	if letter_data.id >= max_id:
		max_id = letter_data.id

func _check_letter_discovery(scratch_delta):
	var rand_upper = max_id * 10
	var rand_lower = min_id
	var selection = randi_range(min_id, max_id)
	return selection
	
func _calc_discoverable_difficulty():
	for letter in Discoveries.letters:
		var letter_data = Discoveries.letters[letter]
		var segments = 16
		var segments_needed = letter_data.segments
		# Calculate the number of combinations (n choose k)
		var total_ways = float(factorial(segments)) / (float(factorial(segments_needed)) * float(factorial(segments - segments_needed)))
		# The number of favorable outcomes (selecting 2 specific cards) is 1
		var favorable_outcomes = 1.0  # Use float here to ensure floating-point division
		# Calculate the probability
		var probability = favorable_outcomes / total_ways
		var rolls_needed = _calc_number_of_rolls_needed(probability)
		var rolls_needed_randomized = randi_range(int(rolls_needed*.8), int(rolls_needed*1.2))
		Discoveries.letters[letter].chance = rolls_needed_randomized

# Helper function to calculate the factorial of a number
func factorial(n):
	if n == 0 or n == 1:
		return 1
	var result = 1
	for i in range(2, n + 1):
		result *= i
	return result

func _calc_number_of_rolls_needed(probability):
	var probability_not_rolling = 1 - probability
	var confidence_level = 0.95
	var n = ceil(log(1 - confidence_level) / log(probability_not_rolling))
	return n

#func save_discoveries():
#	var saveable_discoveries = {}
#	for letter in Discoveries.letters:
#		saveable_discoveries[letter] = {
#			"discovered": Discoveries.letters[letter].discovered,
#			"chance": Discoveries.letters[letter].chance,
#			"discoverable": Discoveries.letters[letter].discoverable
#		}
#	SaveSystem.set_var("discoveries", saveable_discoveries)
#	SaveSystem.set_var("discovery_counter", discovery_counter)
#	SaveSystem.save()
#
#func load_discoveries():
#	var loaded_discoveries = SaveSystem.get_var("discoveries", {})
#	for letter in loaded_discoveries:
#		if letter in Discoveries.letters:
#			Discoveries.letters[letter].discovered = loaded_discoveries[letter].discovered
#			Discoveries.letters[letter].chance = loaded_discoveries[letter].chance
#			Discoveries.letters[letter].discoverable = loaded_discoveries[letter].discoverable

	discovery_counter = SaveSystem.get_var("discovery_counter", 0)

	# Update the visual representation of discovered letters
	_update_letter_visuals()
	
func _update_letter_visuals():
	for node in get_tree().get_nodes_in_group("letter_text"):
		if node.name in Discoveries.letters:
			var letter_data = Discoveries.letters[node.name]
			if letter_data.discovered:
				node.add_theme_color_override("font_color", Color.GREEN)
			else:
				node.remove_theme_color_override("font_color")
		else:
			print("Warning: Letter '" + node.name + "' not found in Discoveries.letters")
			node.remove_theme_color_override("font_color")
