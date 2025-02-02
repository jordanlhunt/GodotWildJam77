extends GridContainer

class_name ShapeData

var color: Color
var grid: Array # Actual cells
var coordinates: Array

func rotate_left() -> void:
	_rotate_grid(-1, 1)

func rotate_right() -> void:
	_rotate_grid(1, -1)

func _rotate_grid(sign_of_x, sign_of_y) -> void:
	var rotated_grid = grid.duplicate(true)
	for x in coordinates:
		for y in coordinates:
			# Map x and y to array indices
			var x1 = coordinates.find(x)
			var y1 = coordinates.find(y)
			var x2 = coordinates.find(sign_of_y * y)
			var y2 = coordinates.find(sign_of_x * x)
			rotated_grid[y1][x1] = grid[y2][x2]
	grid = rotated_grid
