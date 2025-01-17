extends CenterContainer

@onready var playAreaGrid := get_node("PanelContainer/HBoxContainer/RightSide/PlayAreaGrid")
@onready var nextShapeGrid := get_node("PanelContainer/HBoxContainer/LeftSide/VBox/NextShapeContainer/NextShapeGrid")
@onready var aboutBox := get_node("AboutBox")

const TOTAL_CELLS: int = 200
const CELL_BACKGROUND: Color = Color(.1, .1, .1) # Off-black
const TRANSPARENT: Color = Color(0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_cells(playAreaGrid, TOTAL_CELLS)
	clear_cells(playAreaGrid, CELL_BACKGROUND)
	clear_cells(nextShapeGrid, TRANSPARENT)

func add_cells(node, numOfCellsToAdd: int) -> void:
	var currentNumberOfCells = node.get_child_count()
	while currentNumberOfCells < numOfCellsToAdd:
		node.add_child(node.get_child(0).duplicate())
		currentNumberOfCells += 1

func clear_cells(node, color: Color) -> void:
	for cell in node.get_children():
		cell.modulate = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


## Button Presses

func _on_about_pressed() -> void:
	aboutBox.popup_centered()
	emit_signal("button_pressed","About")


func _on_music_toggle_pressed() -> void:
	emit_signal("button_pressed","Music")

func _on_pause_pressed() -> void:
	emit_signal("button_pressed","Pause")


func _on_new_game_pressed() -> void:
	emit_signal("button_pressed","NewGame")
