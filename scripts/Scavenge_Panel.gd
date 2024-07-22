extends PanelContainer
@onready var scavenge_path = %Scavenge_Path
@onready var scavenge_field = %Scavenge_Field
@onready var scavenge_trace = %Scavenge_Trace
var curve := Curve2D.new()
var max_distance := 50.0  # Maximum distance the path can go
@onready var trace_dissapearance_timer = %Trace_Dissapearance_Timer
@onready var scavenge_loot_canvas = %Scavenge_Loot_Canvas
@onready var scavenge_health_bar = %scavenge_health_bar
@onready var respawn_timer = %respawn_timer
@onready var dead_panel = %dead_panel
@onready var scavenge_zone_label = %scavenge_zone_label
@onready var scavenge_previous_zone_btn = %scavenge_previous_zone_btn
@onready var scavenge_next_zone_btn = %scavenge_next_zone_btn
@onready var scavenge_landmarks_collected_label = %scavenge_landmarks_collected_label
@onready var scavenge_landmarks_needed_label = %scavenge_landmarks_needed_label
@onready var weather_label_percent = %weather_label_percent
@onready var scavenge_upgrades_container = %scavenge_upgrades_container
@onready var weather_label = %weather_label
@onready var scavenge_upgrades_pnl = %scavenge_upgrades_pnl

@onready var scavenge_reset_timer = %scavenge_reset_timer
var mouse_hovering = false
@onready var scavenge_coverage_label = %scavenge_coverage_label
@onready var scavenge_landmarks_label = %scavenge_landmarks_label
@onready var scavenge_hazards_label = %scavenge_hazards_label
@onready var scavenge_resource_label = %scavenge_resource_label
@onready var dead_progress = %dead_progress

var health = 100
var start_position := Vector2.ZERO  # Stores the initial mouse position
var current_position := Vector2.ZERO  # Stores the current mouse position
var path_data := PackedVector2Array()  # Stores the points of the drawn path
var state = 0

var hazard_base_qty = 5
var hazard_max_qty = 16
var zonelandmarks_base_qty = 1
var zonelandmarks_max_qty = 1
var resources_base_qty = 3
var resources_max_qty = 8
var current_zone
var hazard_collided = 0
var landmarks_collided = 0
var resources_collided = 0
var current_landmarks_collected = 0
func _ready():
	Upgrades.shop_items["Scavenger"].upgrade_target = [self]
	Upgrades.shop_items["ScavengerTraining"].upgrade_target = [scavenge_upgrades_pnl]
	Upgrades.shop_items["Meteorology"].upgrade_target = [weather_label, weather_label_percent]
	scavenge_trace.get_parent().move_child(scavenge_trace, -1)
var next_zone_number = Stats.current_scavenge_zone + 1
var next_zone

var total_path_length := 0.0
func _process(delta):
	max_distance = Upgrades.shop_items["PackedCamp"].bought * 20 + 50
	_calc_current_weather()
	Stats.current_weather = displayed_weather
	next_zone_number = Stats.current_scavenge_zone + 1
	for zone in Zones.zone_list:
		if Zones.zone_list[zone].id == Stats.current_scavenge_zone:
			current_zone = Zones.zone_list[zone]
	for zone in Zones.zone_list:
		if Zones.zone_list[zone].id == next_zone_number:
			next_zone = Zones.zone_list[zone]
	if next_zone == null:
		print("ba")
		scavenge_next_zone_btn.modulate.a = 0
	else:
		print("me")
		scavenge_next_zone_btn.modulate.a = 1
	_set_zone_spawn_Rates()
	_check_health()
	_hide_previous_zone_button_if_necessary()
	scavenge_zone_label.text = current_zone.name
	scavenge_landmarks_collected_label.text = str(current_landmarks_collected)
	scavenge_landmarks_needed_label.text = str(current_zone.landmarks_needed_to_progress)
		
	if state == 4:
		dead_panel.visible = true
		dead_progress.value = 100 - (respawn_timer.time_left / respawn_timer.wait_time * 100)
	else:
		dead_panel.visible = false
	if state == 0:
		scavenge_field.color = current_zone.color
		if mouse_hovering:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				start_position = get_viewport().get_mouse_position()
				current_position = start_position
				path_data.append(start_position)
				curve.add_point(start_position)
				scavenge_path.curve = curve
				scavenge_trace.points = curve.get_baked_points()
				total_path_length = 0.0  # Reset the path length
				state = 1
	elif state == 1:
		if InputEventMouseMotion:
			if mouse_hovering:
				var new_position = get_viewport().get_mouse_position()
				var segment_length = current_position.distance_to(new_position)
				total_path_length += segment_length

				if total_path_length <= max_distance:
					current_position = new_position
					path_data.append(current_position)
					curve.add_point(current_position)
					scavenge_path.curve = curve
					scavenge_trace.points = curve.get_baked_points()
				else:
					# Path is too long, stop drawing
					trace_dissapearance_timer.start()
					state = 2
					hide_scavenge_field()
			if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				trace_dissapearance_timer.start()
				state = 2    
				hide_scavenge_field()
	elif state == 2:
		state = 3
		var hazard_qty = randi_range(hazard_base_qty, hazard_max_qty)
		var zonelandmarks_qty = randi_range(zonelandmarks_base_qty, zonelandmarks_max_qty)
		var resources_qty = randi_range(resources_base_qty, resources_max_qty)
		_generate_scavenge(hazard_qty, zonelandmarks_qty, resources_qty, scavenge_trace)
		_scavenge_preparations_upgrade()
		_scavenge_health_upgrade()
		scavenge_health_bar.value = health
		scavenge_coverage_label.text = "44%"
		scavenge_hazards_label.text = str(hazard_collided)
		scavenge_landmarks_label.text = str(landmarks_collided)
		scavenge_resource_label.text = str(resources_collided)
		current_landmarks_collected += landmarks_collided
		_generate_resources(resources_collided)
		scavenge_reset_timer.start()
	
func _generate_resources(resources_collided):
	var i = 0
	while i < resources_collided:
		var key = WeightedChoice.pick(current_zone.potential_resources, "rarity")
		var selected_resource_name = current_zone.potential_resources[key].name
		var base_value = 1
		if selected_resource_name == "bananas":
			if Upgrades.shop_items["SkilledGatherer"].bought > 0:
				base_value = Upgrades.shop_items["SkilledGatherer"].bought
		if selected_resource_name == "wood":
			if Upgrades.shop_items["HandSaw"].bought > 0:
				base_value = Upgrades.shop_items["HandSaw"].bought
		Increments.increment_resource(selected_resource_name, base_value)
		i += 1
func _check_health():
	if health <= 0:
		state = 4
		scavenge_field.color = Color.DIM_GRAY
		if respawn_timer.is_stopped():
			respawn_timer.start()

func _hide_previous_zone_button_if_necessary():
	if Stats.current_scavenge_zone == 1:
		scavenge_previous_zone_btn.modulate.a = 0
	else:
		scavenge_previous_zone_btn.modulate.a = 1	
func _set_zone_spawn_Rates():
	hazard_base_qty = current_zone.base_hazard_spawn
	hazard_max_qty = current_zone.max_hazard_spawn
	zonelandmarks_base_qty = current_zone.base_landmark_spawn
	zonelandmarks_max_qty = current_zone.max_landmark_spawn
	resources_base_qty = current_zone.base_resource_spawn
	resources_max_qty = current_zone.max_resource_spawn
		
		
func _scavenge_preparations_upgrade():
	if Upgrades.shop_items["Preparations"].bought:
		if hazard_collided > 0:
			hazard_collided -= 1

func _scavenge_health_upgrade():
	if Upgrades.shop_items["NaturalRemedies"].bought:
		if resources_collided > 0:
			var i = 0
			while i < resources_collided:
				var heal_roll = randi_range(0, 100)
				if heal_roll <= 10:
					Increments.increment_resource("health", Upgrades.shop_items["NaturalRemedies"].bought)
					if health > 100:
						health = 100
				i += 1
		
func hide_scavenge_field():
	scavenge_field.color = Color.WHITE  # Hide the ColorRect

func _on_trace_dissapearance_timer_timeout():
	scavenge_trace.points = PackedVector2Array()

func _generate_scavenge(hazard_qty, zonelandmarks_qty, resources_qty, scavenge_trace):
	# Spawn hazards (red squares)
	for i in range(hazard_qty):
		var hazard = Polygon2D.new()
		hazard.color = Color(1, 0, 0)  # Red color
		var square_size = 10
		var square_points = PackedVector2Array([
			Vector2(0, 0),
			Vector2(square_size, 0),
			Vector2(square_size, square_size),
			Vector2(0, square_size)
		])
		hazard.polygon = square_points
		hazard.position = get_random_position()  # Set a random position within the scavenge field
		scavenge_loot_canvas.add_child(hazard)
		_check_line_collision(hazard, "hazard")

	# Spawn zone landmarks (blue hexagons)
	for i in range(zonelandmarks_qty):
		var landmark = Marker2D.new()
		var hexagon = Polygon2D.new()
		hexagon.color = Color(0, 0, 1)  # Blue color
		var hexagon_radius = 10
		var hexagon_points = PackedVector2Array()
		var num_segments = 6
		for j in range(num_segments):
			var angle = 2 * PI * j / num_segments
			var x = hexagon_radius * cos(angle)
			var y = hexagon_radius * sin(angle)
			hexagon_points.append(Vector2(x, y))
		hexagon.polygon = hexagon_points
		hexagon.position = get_random_position()  # Set a random position within the scavenge field
		landmark.add_child(hexagon)
		scavenge_loot_canvas.add_child(landmark)
		_check_line_collision(hexagon, "landmark")

	# Spawn resources (yellow triangles)
	for i in range(resources_qty):
		var resource = Polygon2D.new()
		resource.color = Color(1, 1, 0)  # Yellow color
		resource.polygon = PackedVector2Array([
			Vector2(0, -10),
			Vector2(10, 10),
			Vector2(-10, 10)
		])  # Set the polygon points to create a triangle
		resource.position = get_random_position()  # Set a random position within the scavenge field
		scavenge_loot_canvas.add_child(resource)
		_check_line_collision(resource, "resource")
	var weather_health_penalty = displayed_weather / 50
	_handle_infrastructure_militia()
	health -= 10 * weather_health_penalty * hazard_collided
	Increments.increment_resource("health", health)
	
func get_random_position():
	var occlusion_offset = 20
	var x = randf_range(0 + occlusion_offset, scavenge_field.size.x - occlusion_offset) + scavenge_field.global_position.x
	var y = randf_range(0 + occlusion_offset, scavenge_field.size.y - occlusion_offset) + scavenge_field.global_position.y
	return Vector2(x, y)
	
func _check_line_collision(input_polygon, type):
	var polygon_global_vectors:PackedVector2Array = []

	for vector in input_polygon.polygon:
		var global_vector = input_polygon.position + vector
		polygon_global_vectors.append(global_vector)

	for point in scavenge_trace.points:
		if Geometry2D.is_point_in_polygon(point, polygon_global_vectors):
			if type == "hazard":
				hazard_collided += 1
			elif type == "landmark":
				landmarks_collided += 1
			elif type == "resource":
				var weather_resource_penalty = (100 - displayed_weather) / 25
				resources_collided += 1
				var key = WeightedChoice.pick(current_zone.potential_resources, "rarity")
				var selected_resource_name = current_zone.potential_resources[key].name
				var base_value = 1
				if selected_resource_name == "bananas":
					if Upgrades.shop_items["SkilledGatherer"].bought > 0:
						base_value = Upgrades.shop_items["SkilledGatherer"].bought
				base_value = int(base_value * weather_resource_penalty)
				Increments.increment_resource(selected_resource_name, base_value)
			return  # Exit the function once a collision is detected
			


func _on_scavenge_field_mouse_entered():
	mouse_hovering = true


func _on_scavenge_field_mouse_exited():
	mouse_hovering = false


func _on_respawn_timer_timeout():
	health = 100
	Resources.health = health
	scavenge_health_bar.value = health
	state = 0


func _on_scavenge_next_zone_btn_pressed():
	if next_zone != null:
		if next_zone.unlocked:
			Stats.current_scavenge_zone += 1
		elif current_landmarks_collected >= current_zone.landmarks_needed_to_progress:
			for zone in Zones.zone_list:
				if Zones.zone_list[zone].id == next_zone.id:
					Zones.zone_list[zone].unlocked = true
					current_landmarks_collected = 0
					Stats.current_scavenge_zone += 1

@onready var weather_adjust_timer = %weather_adjust_timer
@onready var weather_acclimate_timer = %weather_acclimate_timer

var displayed_weather = 50
var current_weather = 50
var next_weather = randi_range(0, 100)
var weather_state = 0
var random_offset = randi_range(-10, 10)
var weather_offset = 0
var weather_color = Color.RED

func _calc_current_weather():
	if weather_state == 0:
		displayed_weather = current_weather
		
		next_weather = randi_range(10, 90)
		weather_adjust_timer.wait_time = 2 * (next_weather % 10) +.1
		weather_adjust_timer.start()
		weather_state = 1
	elif weather_state == 1:
		var timer_prcnt_complete = 1 - (weather_adjust_timer.time_left / weather_adjust_timer.wait_time)
		if weather_adjust_timer.time_left > 0:
			displayed_weather = lerp(current_weather, next_weather, timer_prcnt_complete)
	elif weather_state == 2:
		current_weather = next_weather
		displayed_weather = current_weather
		random_offset = randi_range(-10, 10)
		weather_offset = random_offset + current_weather
		weather_acclimate_timer.start()
		weather_state = 3
	elif weather_state == 3:
		var timer_prcnt_complete = 1 - (weather_acclimate_timer.time_left / weather_acclimate_timer.wait_time)
		if weather_acclimate_timer.time_left > 0:
			displayed_weather = lerp(current_weather, weather_offset, timer_prcnt_complete)
	weather_label_percent.text = str(int(displayed_weather)) + "%"
	if displayed_weather < 50:
		weather_color = lerp (Color.GREEN, Color.YELLOW, displayed_weather / 50)
	else:
		weather_color = lerp (Color.YELLOW, Color.RED, (displayed_weather - 50) / 50)
	weather_label_percent.add_theme_color_override("font_color", weather_color)
		
	

func _on_scavenge_previous_zone_btn_pressed():
	if Stats.current_scavenge_zone > 1:
		Stats.current_scavenge_zone -= 1


func _on_weather_adjust_timer_timeout():
	weather_state = 2



func _on_weather_acclimate_timer_timeout():
	weather_state = 0

func _on_scavenge_reset_timer_timeout():
	for child in scavenge_loot_canvas.get_children():
		child.queue_free()
	state = 0
	hazard_collided = 0
	landmarks_collided = 0
	resources_collided = 0
	scavenge_trace.points = PackedVector2Array()
	path_data = PackedVector2Array()
	curve = Curve2D.new()
	total_path_length = 0.0

func _handle_infrastructure_militia():
	var infra_data = Infrastructure.infra_items["Militia"]
	if Workers.assigned_laborers < Workers.laborers:	
		if infra_data.active:
			hazard_collided -= Workers.laborers - Workers.assigned_laborers
			if hazard_collided < 0:
				hazard_collided = 0
