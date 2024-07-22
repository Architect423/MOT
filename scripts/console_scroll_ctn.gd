extends ScrollContainer
@onready var console_vbox = %console_vbox
@onready var console_scroll_ctn = %console_scroll_ctn


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for log_item in Console.messages:
		var log_lbl = RichTextLabel.new()
		log_lbl.text = log_item
		log_lbl.custom_minimum_size = Vector2(600, 30)
		console_vbox.add_child(log_lbl)
		Console.messages.erase(log_item)
	pass
