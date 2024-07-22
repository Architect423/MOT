extends GridContainer

@onready var letter_grid = %LetterGrid

func _ready():
	reorder_grid_children_by_name(self)


func _process(delta):
	# Reorder children based on their names
	reorder_grid_children_by_name(letter_grid)


func get_child_names(container):
	var names = []
	for child in container.get_children():
		names.append(child.name)
	return names

func reorder_grid_children_by_name(container):
	var children = container.get_children()
	var name_to_child = {}
	# Store current children in a dictionary for easy access
	for child in children:
		name_to_child[child.name] = child
	# Remove all children from the container
	for child in children:
		container.remove_child(child)
	# Convert names to integers, sort them, and add children back in the sorted order
	var sorted_names = name_to_child.keys()
	sorted_names.sort_custom(func(a, b): return int(a) < int(b))
	for name in sorted_names:
		container.add_child(name_to_child[name])

	# Optionally, sort children in the container to match the new order


func clear_children(container):
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()
