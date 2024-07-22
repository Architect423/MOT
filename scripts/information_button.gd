extends Button

@onready var help_info_panel = $help_info_panel

# Called when the node enters the scene tree for the first time.
func _ready():
	help_info_panel.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var panel_state = 0
func _on_pressed():
	if panel_state == 0:
		help_info_panel.visible = false
		panel_state = 1
	else:
		help_info_panel.visible = true
		panel_state = 0
	pass # Replace with function body.
