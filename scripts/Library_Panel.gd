extends PanelContainer
@onready var buy_typewriter_button = %buy_typewriter_button
@onready var typewriter_cost_lbl = %typewriter_cost_lbl
@onready var typewriter_qty = %typewriter_qty
@onready var typewriter_consumed_qty = %typewriter_consumed_qty
@onready var buy_computer_button = %buy_computer_button
@onready var computer_cost_lbl = %computer_cost_lbl
@onready var computer_consumed_qty = %computer_consumed_qty
@onready var computer_qty = %computer_qty
@onready var book_shelf = %book_shelf

var typewriter_cost = 100
var computer_cost = 100
var book_names = {}
var book_years = {}
var book_authors = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	_spawn_books()
	Upgrades.shop_items["Library"].upgrade_target = [self]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	typewriter_cost_lbl.text = str(typewriter_cost) + " Scratches"
	typewriter_qty.text = str(Library.typewriters)
	typewriter_consumed_qty.text = str(Workers.worker_types["Typist"].assigned)
	
	computer_cost_lbl.text = str(computer_cost) + " Scratches"
	computer_qty.text = str(Library.computers)
	computer_consumed_qty.text = str(Workers.worker_types["Editor"].assigned)
	
	for book in Books.list:
		var book_data = Books.list[book]
		if Resources.words > book_data.words:
			Books.list[book].discovered = true
		if book_data.discovered:
			book_years[book].add_theme_color_override("font_color", Color.GREEN)
			book_names[book].add_theme_color_override("font_color", Color.GREEN)
			book_authors[book].add_theme_color_override("font_color", Color.GREEN)
	pass


func _on_buy_typewriter_button_pressed():
	if Resources.scratches >= typewriter_cost:
		Resources.scratches -= typewriter_cost
		Library.typewriters += 1


func _on_buy_computer_button_pressed():
	if Resources.scratches >= computer_cost:
		Resources.scratches -= computer_cost
		Library.computers += 1

func _spawn_books():
	for book in Books.list:
		var book_panel = PanelContainer.new()
		var book_spacer = Control.new()
		book_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
		var book_data = Books.list[book]
		var book_vbox = VBoxContainer.new()
		var book_name = Label.new()
		book_name.text = book_data.name
		var book_author = Label.new()
		book_author.text = book_data.author
		var book_year = Label.new()
		book_year.text = book_data.year
		var book_icon = TextureRect.new()
		book_icon.texture = preload("res://book-open-variant.png")
		book_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		book_icon.custom_minimum_size = Vector2(50, 50)
		book_name.theme = preload("res://fonts/medium_ui_element.tres")
		book_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		book_author.theme = preload("res://fonts/small_ui_element.tres")
		book_author.horizontal_alignment =HORIZONTAL_ALIGNMENT_CENTER
		book_year.theme = preload("res://fonts/small_ui_element.tres")
		book_year.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		book_years[book] = book_year
		book_names[book] = book_name
		book_authors[book] = book_author
		book_vbox.add_child(book_name)
		book_vbox.add_child(book_spacer)
		book_vbox.add_child(book_icon)
		book_vbox.add_child(book_author)
		book_vbox.add_child(book_year)
		book_panel.add_child(book_vbox)
		book_shelf.add_child(book_panel)

