extends GridContainer


var _shapes: Array = []
var _index: int = 0

func get_shape() -> ShapeData:
	if _index == 0:
		_shapes.shuffle()
		_index = _shapes.size()
	_index = _index - 1
	var shapeData = ShapeData.new()
	shapeData.name = _shapes[_index].name
	shapeData.color = _shapes[_index].color
	shapeData.coordinates = _shapes[_index].coordinates
	shapeData.grid = _shapes[_index].grid
	return shapeData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for shape in get_children():
		var data = ShapeData.new()
		var shape_size = shape.columns
		data.name = shape.name
		data.color = shape.modulate
		# Shape itself
		var size2 = shape_size / 2
		data.coordinates = range(-size2, size2 + 1)
		# Remove the zero coordinate for the even-sized grids
		if shape_size % 2 == 0:
			data.coordinates.remove_at(size2)
		print(data.coordinates)
		data.grid = _get_grid(shape_size, shape.get_children())
		_shapes.append(data)

func _get_grid(size_of_grid, cells):
	var grid: Array = []
	var row: Array = []
	var i: int = 0
	for cell in cells:
		row.append(cell.modulate.a > 0.1)
		i += 1
		if i == size_of_grid:
			grid.append(row)
			i = 0
			row = []
	return grid

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
