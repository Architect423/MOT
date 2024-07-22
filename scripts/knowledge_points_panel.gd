extends PanelContainer
@onready var knowledge_points_vbox = %knowledge_points_vbox

var perk_buttons = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	var spacer = Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var i = 0
	while i < KnowledgePoints.branches:
		i += 1
		var branch_hbox = HBoxContainer.new()
		var j = 0
		while j < KnowledgePoints.tiers:
			j += 1
			var tier_vbox = VBoxContainer.new()
			tier_vbox.add_child(spacer.duplicate())
			for upgrade in KnowledgePoints.upgrades:
				var upgrade_data = KnowledgePoints.upgrades[upgrade]
				if upgrade_data.branch == i && upgrade_data.tier == j:
					var upgrade_btn = Button.new()
					upgrade_btn.toggle_mode = true
					KnowledgePoints.upgrades[upgrade]["btn"] = upgrade_btn
					upgrade_btn.pressed.connect(Callable(self, "_btn_pressed").bind(upgrade_data))
					upgrade_btn.custom_minimum_size = Vector2(40,40)
					tier_vbox.add_child(upgrade_btn)
					tier_vbox.add_child(spacer.duplicate())
			tier_vbox.add_child(spacer.duplicate())
			branch_hbox.add_child(spacer.duplicate())
			branch_hbox.add_child(tier_vbox)
			branch_hbox.add_child(spacer.duplicate())
			branch_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		knowledge_points_vbox.add_child(branch_hbox)
		
	pass # Replace with function body.

func _btn_pressed(upgrade_data):
	var upgrade_btn = upgrade_data.get("btn")
	for upgrade in KnowledgePoints.upgrades:
		var upgrade_precursor_data = KnowledgePoints.upgrades[upgrade]
		if upgrade_precursor_data.tier == upgrade_data.tier - 1:
			if not upgrade_precursor_data.bought:
				upgrade_btn.button_pressed = false
				return
	if upgrade_btn.button_pressed:
		var bought_upgrades = 0
		for upgrade in KnowledgePoints.upgrades:
			if KnowledgePoints.upgrades[upgrade].bought:
				bought_upgrades += 1
		if bought_upgrades < KnowledgePoints.knowledge_points:
			print(bought_upgrades)
			upgrade_data.bought = true
		else:
			upgrade_btn.button_pressed = false
	else:
		upgrade_data.bought = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for upgrade in KnowledgePoints.upgrades:
		var upgrade_data = KnowledgePoints.upgrades[upgrade]
		if upgrade_data.tier > 1:
			if upgrade_data.bought:
				for upgrade_precursor in KnowledgePoints.upgrades:
					var upgrade_precursor_data = KnowledgePoints.upgrades[upgrade_precursor]
					if upgrade_precursor_data.tier == upgrade_data.tier - 1:
						if not upgrade_precursor_data.bought:
							var upgrade_btn = upgrade_data.get("btn")
							upgrade_btn.button_pressed = false
							upgrade_data.bought = false
