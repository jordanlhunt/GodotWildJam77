extends Control
signal pressed


@onready var aboutBox := get_node("AboutBox")
@onready var aboutButton := get_node("PanelContainer/HBoxContainer/LeftSide/VBox/About")
@onready var highScoreValue := get_node("PanelContainer/HBoxContainer/LeftSide/VBox/PlayerDataGrid/HighScoreValue")
@onready var levelValue := get_node("PanelContainer/HBoxContainer/LeftSide/VBox/PlayerDataGrid/LevelValue")
@onready var linesValue := get_node("PanelContainer/HBoxContainer/LeftSide/VBox/PlayerDataGrid/LinesValue")
@onready var newGameButton := get_node("PanelContainer/HBoxContainer/LeftSide/VBox/NewGame")
@onready var nextShapeGrid := get_node("PanelContainer/HBoxContainer/LeftSide/VBox/NextShapeContainer/NextShapeGrid")
@onready var pauseButton := get_node("PanelContainer/HBoxContainer/LeftSide/VBox/Pause")
@onready var playAreaGrid := get_node("PanelContainer/HBoxContainer/RightSide/PlayAreaGrid")
@onready var scoreValue := get_node("PanelContainer/HBoxContainer/LeftSide/VBox/PlayerDataGrid/ScoreValue")
@onready var musicSliderNode := get_node("PanelContainer/HBoxContainer/LeftSide/VBox/MusicSliderContainer/MusicSlider")
@onready var soundSliderNode := get_node("PanelContainer/HBoxContainer/LeftSide/VBox/HBoxContainer/SoundSlider")

var current_music: float = 0
var current_sound: float = 0

const TOTAL_CELLS: int = 200
const CELL_BACKGROUND: Color = Color(.1, .1, .1) # Off-black
const TRANSPARENT: Color = Color(0)

#Properties

var level: int = 1:
	get:
		return level
	set(value):
		levelValue.text = str(value)
		level = value

var score: int = 0:
	get:
		return score
	set(value):
		scoreValue.text = str(value)
		score = value

var high_score: int = 0:
	get:
		return high_score
	set(value):
		highScoreValue.text = str(value)
		high_score = value

var lines: int = 0:
	get:
		return high_score
	set(value):
		linesValue.text = str(value)
		lines = value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Setup Labels
	setup_label_values()
	add_cells(playAreaGrid, TOTAL_CELLS)
	clear_all_cells()

func add_cells(node, numOfCellsToAdd: int) -> void:
	var currentNumberOfCells = node.get_child_count()
	while currentNumberOfCells < numOfCellsToAdd:
		node.add_child(node.get_child(0).duplicate())
		currentNumberOfCells += 1

func clear_all_cells() -> void:
	clear_cells(playAreaGrid)
	clear_cells(nextShapeGrid)

func clear_cells(node) -> void:
	for cell in node.get_children():
		cell.modulate = TRANSPARENT

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
func setup_label_values() -> void:
		levelValue.text = str(level)
		scoreValue.text = str(score)
		linesValue.text = str(lines)
		highScoreValue.text = "%07d" % (high_score)

func reset_stats(new_high_score = 0, new_score = 0, new_lines = 0, new_level = 0) -> void:
		level = new_level
		score = new_score
		lines = new_lines
		high_score = new_high_score

func settings(data):
	self.high_score = data.high_score
	musicSliderNode.value = data.music
	soundSliderNode.value = data.sound

func set_next_shape(next_shape: ShapeData) -> void:
	clear_cells(next_shape)
	var i: int = 0
	for column in next_shape.coordinates.size():
		for row in [0, 1]:
			if next_shape.grid[row][column]:
				next_shape.get_child(i).modulate = next_shape.color
			i += 1
