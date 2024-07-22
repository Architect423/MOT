extends PanelContainer

@onready var farm_size_label:Label = %farm_size_label
@onready var grow_speed_label:Label = %grow_speed_label
@onready var harvest_yield_label:Label = %harvest_yield_label

var farm_size = 9
var grow_speed = 5
var harvest_yield = 1

@onready var farm_tile_1 = %farm_tile_1
@onready var farm_button_1 = %farm_button_1
@onready var farm_timer_1 = %farm_button_timer_1

@onready var farm_tile_2 = %farm_tile_2
@onready var farm_button_2 = %farm_button_2
@onready var farm_timer_2 = %farm_button_timer_2

@onready var farm_tile_3 = %farm_tile_3
@onready var farm_button_3 = %farm_button_3
@onready var farm_timer_3 = %farm_button_timer_3

@onready var farm_tile_4 = %farm_tile_4
@onready var farm_button_4 = %farm_button_4
@onready var farm_timer_4 = %farm_button_timer_4

@onready var farm_tile_5 = %farm_tile_5
@onready var farm_button_5 = %farm_button_5
@onready var farm_timer_5 = %farm_button_timer_5

@onready var farm_tile_6 = %farm_tile_6
@onready var farm_button_6 = %farm_button_6
@onready var farm_timer_6 = %farm_button_timer_6

@onready var farm_tile_7 = %farm_tile_7
@onready var farm_button_7 = %farm_button_7
@onready var farm_timer_7 = %farm_button_timer_7

@onready var farm_tile_8 = %farm_tile_8
@onready var farm_button_8 = %farm_button_8
@onready var farm_timer_8 = %farm_button_timer_8

@onready var farm_tile_9 = %farm_tile_9
@onready var farm_button_9 = %farm_button_9
@onready var farm_timer_9 = %farm_button_timer_9
@onready var farm_upgrades_container = %farm_upgrades_container
@onready var farmer_tick_timer = %farmer_tick_timer

var start_color = Color.SADDLE_BROWN
var end_color = Color.WEB_GREEN
# Called when the node enters the scene tree for the first time.
var farm_elements
func _ready():
	Upgrades.shop_items["Farm"].upgrade_target = [self]
	farm_upgrades_container.modulate.a = 1
	farm_elements = [
	{ "index": 1, "tile": farm_tile_1, "button": farm_button_1, "timer": farm_timer_1, "growth_status": 0 },
	{ "index": 2, "tile": farm_tile_2, "button": farm_button_2, "timer": farm_timer_2, "growth_status": 0 },
	{ "index": 3, "tile": farm_tile_3, "button": farm_button_3, "timer": farm_timer_3, "growth_status": 0 },
	{ "index": 4, "tile": farm_tile_4, "button": farm_button_4, "timer": farm_timer_4, "growth_status": 0 },
	{ "index": 5, "tile": farm_tile_5, "button": farm_button_5, "timer": farm_timer_5, "growth_status": 0 },
	{ "index": 6, "tile": farm_tile_6, "button": farm_button_6, "timer": farm_timer_6, "growth_status": 0 },
	{ "index": 7, "tile": farm_tile_7, "button": farm_button_7, "timer": farm_timer_7, "growth_status": 0 },
	{ "index": 8, "tile": farm_tile_8, "button": farm_button_8, "timer": farm_timer_8, "growth_status": 0 },
	{ "index": 9, "tile": farm_tile_9, "button": farm_button_9, "timer": farm_timer_9, "growth_status": 0 }
	]
	# Connect timer timeout signals
	farm_timer_1.timeout.connect(_on_farm_timer_1_timeout)
	farm_timer_2.timeout.connect(_on_farm_timer_2_timeout)
	farm_timer_3.timeout.connect(_on_farm_timer_3_timeout)
	farm_timer_4.timeout.connect(_on_farm_timer_4_timeout)
	farm_timer_5.timeout.connect(_on_farm_timer_5_timeout)
	farm_timer_6.timeout.connect(_on_farm_timer_6_timeout)
	farm_timer_7.timeout.connect(_on_farm_timer_7_timeout)
	farm_timer_8.timeout.connect(_on_farm_timer_8_timeout)
	farm_timer_9.timeout.connect(_on_farm_timer_9_timeout)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	propogation_chance = Upgrades.shop_items["Propogation"].bought
	for farm_cell in farm_elements:
		farm_cell.timer.wait_time = grow_speed
		if farm_cell.growth_status == 0:
			farm_cell.tile.color = start_color
		elif farm_cell.growth_status == 1:
			var progress = 1.0 - (farm_cell["timer"].time_left / farm_cell["timer"].wait_time)
			var color = start_color.lerp(end_color, progress)
			farm_cell.tile.color = color
	farm_size_label.text = str(farm_size)
	grow_speed_label.text = str(grow_speed)
	harvest_yield_label.text = str(harvest_yield)
	farm_size = pow(9, Upgrades.shop_items["IncreaseSize"].bought + 1)
	grow_speed = 5 * pow(.8, Upgrades.shop_items["Fertilizer"].bought + 1)
	if Resources.scratches > 10:
		self.modulate.a = 1
	if Resources.scratches > 15:
		farm_upgrades_container.modulate.a = 1
	_handle_farmer()
	

func _handle_farmer():
	if Workers.worker_types["Farmer"].assigned > 9:
		farmer_tick_timer.wait_time = 5 * pow(.98, Workers.worker_types["Farmer"].assigned)
	if Workers.worker_types["Farmer"].assigned > 0:
		if farmer_tick_timer.is_stopped():
			farmer_tick_timer.start()
			var i = 0
			for farm_cell in farm_elements:
				if farm_cell.growth_status == 0 || farm_cell.growth_status == 2:
					_clicked_farm_tile(farm_cell.index)	
					i += 1
					if i >= Workers.worker_types["Farmer"].assigned:
						return
					elif i >= 9:
						return
					
signal farm_tile_harvested
var propogation_chance = 0
func _clicked_farm_tile(tile_number):
	var farm_cell = farm_elements[tile_number-1]
	if farm_cell.growth_status == 0:
		if Resources.bananas >= pow(9, Upgrades.shop_items["IncreaseSize"].bought):
			Resources.bananas -= pow(9, Upgrades.shop_items["IncreaseSize"].bought)
			farm_cell.growth_status = 1
			farm_cell["timer"].start()
	elif farm_cell.growth_status == 2:
		farm_tile_harvested.emit()
		var roll = randi_range(0, 100)
		if roll > propogation_chance:
			farm_cell.growth_status = 0
		var base_gain = Upgrades.shop_items["SelectiveHarvesting"].bought + 2
		if Upgrades.shop_items["GrowingSeason"].bought > 0:
			if Stats.current_weather <= 60:
				base_gain * (Upgrades.shop_items["GrowingSeason"].bought + 1)
		Increments.increment_resource("bananas", base_gain)

func _hoe_activated(hoe_tiles):
	for tile in hoe_tiles:
		for cell in farm_elements:
			if tile == cell["index"]:
				if cell["growth_status"] == 0:
					_clicked_farm_tile(tile)

func _scythe_activated(scythe_tiles):
	for tile in scythe_tiles:
		for cell in farm_elements:
			if tile == cell["index"]:
				if cell["growth_status"] == 2:
					_clicked_farm_tile(tile)
					
func _check_hoe(farm_tile, hoe_tiles):
	for element in farm_elements:
		if element["index"] == farm_tile:
			if element["growth_status"] == 0:
				if Upgrades.shop_items["Hoe"].bought:
					_hoe_activated(hoe_tiles)

func _check_scythe(farm_tile, scythe_tiles):
	for element in farm_elements:
		if element["index"] == farm_tile:
			if element["growth_status"] == 2:
				if Upgrades.shop_items["Scythe"].bought:
					_scythe_activated(scythe_tiles)				
	
func _on_farm_button_9_pressed():
	var farm_tile = 9
	var hoe_tiles = [8, 6]
	_check_hoe(farm_tile, hoe_tiles)
	_check_scythe(farm_tile, hoe_tiles)
	_clicked_farm_tile(farm_tile)
	


func _on_farm_button_8_pressed():
	var farm_tile = 8
	var hoe_tiles = [7, 9, 5]
	_check_hoe(farm_tile, hoe_tiles)
	_check_scythe(farm_tile, hoe_tiles)
	_clicked_farm_tile(farm_tile)



func _on_farm_button_7_pressed():
	var farm_tile = 7
	var hoe_tiles = [4, 8]
	_check_hoe(farm_tile, hoe_tiles)
	_check_scythe(farm_tile, hoe_tiles)
	_clicked_farm_tile(farm_tile)


func _on_farm_button_6_pressed():
	var farm_tile = 6
	var hoe_tiles = [3, 5, 9]
	_check_hoe(farm_tile, hoe_tiles)
	_check_scythe(farm_tile, hoe_tiles)
	_clicked_farm_tile(farm_tile)


func _on_farm_button_5_pressed():
	var farm_tile = 5
	var hoe_tiles = [2, 4, 6, 8]
	_check_hoe(farm_tile, hoe_tiles)
	_check_scythe(farm_tile, hoe_tiles)
	_clicked_farm_tile(farm_tile) 


func _on_farm_button_4_pressed():
	var farm_tile = 4
	var hoe_tiles = [1, 5, 7]
	_check_hoe(farm_tile, hoe_tiles)
	_check_scythe(farm_tile, hoe_tiles)
	_clicked_farm_tile(farm_tile)


func _on_farm_button_3_pressed():
	var farm_tile = 3
	var hoe_tiles = [2, 6]
	_check_hoe(farm_tile, hoe_tiles)
	_check_scythe(farm_tile, hoe_tiles)
	_clicked_farm_tile(farm_tile) 


func _on_farm_button_2_pressed():
	var farm_tile = 2
	var hoe_tiles = [1, 3, 5]
	_check_hoe(farm_tile, hoe_tiles)
	_check_scythe(farm_tile, hoe_tiles)
	_clicked_farm_tile(farm_tile)


func _on_farm_button_1_pressed():
	var farm_tile = 1
	var hoe_tiles = [4, 2]
	_check_hoe(farm_tile, hoe_tiles)
	_check_scythe(farm_tile, hoe_tiles)
	_clicked_farm_tile(farm_tile) 

func _on_farm_timer_1_timeout():
	_handle_farm_timer_timeout(1)

func _on_farm_timer_2_timeout():
	_handle_farm_timer_timeout(2)

func _on_farm_timer_3_timeout():
	_handle_farm_timer_timeout(3)

func _on_farm_timer_4_timeout():
	_handle_farm_timer_timeout(4)

func _on_farm_timer_5_timeout():
	_handle_farm_timer_timeout(5)

func _on_farm_timer_6_timeout():
	_handle_farm_timer_timeout(6)

func _on_farm_timer_7_timeout():
	_handle_farm_timer_timeout(7)

func _on_farm_timer_8_timeout():
	_handle_farm_timer_timeout(8)

func _on_farm_timer_9_timeout():
	_handle_farm_timer_timeout(9)

func _handle_farm_timer_timeout(tile_number):
	var farm_cell = farm_elements[tile_number - 1]
	if farm_cell.growth_status == 1:
		farm_cell.growth_status = 2
