extends Button
@onready var prestige_popup = %prestige_popup


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_down():
	if prestige_popup.visible:
		prestige_popup.visible = false
	else:
		prestige_popup.visible = true
