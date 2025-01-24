extends Control
signal pressed

@onready var playAreaGrid := get_node("PanelContainer/HBoxContainer/RightSide/PlayAreaGrid")
@onready var nextShapeGrid := get_node("PanelContainer/HBoxContainer/LeftSide/VBox/NextShapeContainer/NextShapeGrid")
@onready var aboutBox := get_node("AboutBox")
@onready var newGameButton := get_node("PanelContainer/HBoxContainer/LeftSide/VBox/NewGame")
@onready var pauseButton := get_node("PanelContainer/HBoxContainer/LeftSide/VBox/Pause")
@onready var aboutButton := get_node("PanelContainer/HBoxContainer/LeftSide/VBox/About")

var current_music: float = 0
var current_sound: float = 0

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

# Button Presses
func _on_about_pressed() -> void:
	aboutBox.popup_centered()
	pressed.emit("About")

func _on_new_game_pressed() -> void:
	pressed.emit("NewGame")

func _set_button_state(button: Button, state: bool) -> void:
	button.set_disabled(state)

func set_button_text(button: Button, new_text: String) -> void:
	button.set_text(new_text)

func set_button_states(is_playing: bool) -> void:
	_set_button_state(newGameButton, is_playing)
	_set_button_state(aboutButton, is_playing)
	_set_button_state(pauseButton, !is_playing)

func _on_pause_pressed() -> void:
	pressed.emit("Pause")

func _on_music_slider_value_changed(value: float) -> void:
	current_music = value
	pressed.emit("Music")

func _on_sound_slider_value_changed(value: float) -> void:
	current_sound = value
	pressed.emit("Value")
