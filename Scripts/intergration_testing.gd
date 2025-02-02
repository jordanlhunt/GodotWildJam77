extends Control

@onready var shape_label := get_node("Shape")
@onready var grid_label := get_node("Grid")
@onready var mainNode := get_node("Main")
@onready var spinBox := get_node("SpinBox")


var current_shape: ShapeData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pick_shape_pressed() -> void:
	current_shape = Shapes.get_shape()
	shape_label.text = str(current_shape.name)
	_show_grid()


func _on_rotate_left_pressed() -> void:
	current_shape.rotate_left()
	_show_grid()


func _on_rotate_right_pressed() -> void:
	current_shape.rotate_right()
	_show_grid()
	

func _show_grid():
	grid_label.text = ""
	for row in current_shape.grid:
		for col in row:
			if col:
				grid_label.text += "X"
			else:
				grid_label.text += "_"
		grid_label.text += "\n"


func _on_place_shape_pressed() -> void:
	pass # Replace with function body.


func _on_add_shape_to_grid_pressed() -> void:
	mainNode.clear_grid()
	mainNode.currentShapeData = Shapes.get_shape()
	mainNode.currentShapePosition = int(spinBox.value)
	mainNode.add_shape_to_grid()


func _on_remove_shape_from_grid_pressed() -> void:
	mainNode.remove_shape_from_grid()


func _on_lock_button_pressed() -> void:
	mainNode.lock_shape_to_grid()
