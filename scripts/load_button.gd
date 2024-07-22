extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	Resources.load_resources()
	Upgrades.load_upgrades()
	EducationTiers.load_education_tiers()
	Workers.load_workers_types()
	pass # Replace with function body.
