extends Node
enum {
	STOPPED,
	PLAYING,
	PAUSED,
	STOP,
	PLAY,
	PAUSE
 }
enum {
	LEFT,
	RIGHT
}
@onready var guiNode := get_node("GUI")
@onready var musicPlayerNode := get_node("AudioStream")
@onready var timerNode := get_node("Timer")
var current_state = STOPPED
var music_position = 0.0
var pauseButton: BaseButton
var playButton: BaseButton
var musicSlider: HSlider
var soundSlider: HSlider
var MIN_AUDIO_LEVEL
var grid_cell_occupied = []
var number_of_columns: int
var currentShapeData: ShapeData
var nextShape: ShapeData
var currentShapePosition = 0
var total_dropped_shapes = 0
const ENABLED: bool = false
const DISABLED: bool = true
const STARTING_SHAPE_POSITION: int = 5
const TICK_SPEED: float = 1.0
const SOFT_DROP_MULTIPLE: int = 10
const MAX_LEVEL: int = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playButton = guiNode.find_child("NewGame")
	pauseButton = guiNode.find_child("Pause")
	musicSlider = guiNode.find_child("MusicSlider")
	soundSlider = guiNode.find_child("SoundSlider")
	MIN_AUDIO_LEVEL = musicSlider.min_value
	soundSlider.min_value = MIN_AUDIO_LEVEL
	current_state = STOPPED
	playButton.pressed.connect(_button_pressed.bind(playButton.name))
	pauseButton.pressed.connect(_button_pressed.bind(pauseButton.name))
	musicSlider.value_changed.connect(_slider_value_changed.bind(musicSlider.name))
	soundSlider.value_changed.connect(_slider_value_changed.bind(soundSlider.name))
	guiNode.set_button_states(ENABLED)
	number_of_columns = guiNode.playAreaGrid.get_columns()
	# Seed the random generator
	randomize()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _button_pressed(button_name) -> void:
	match button_name:
		"NewGame":
			guiNode.set_button_states(DISABLED)
			_start_game()
		"Pause":
			if current_state == PLAYING:
				guiNode.set_button_text(pauseButton, "Resume")
				current_state = PAUSED
				_set_music(PAUSE)
			else:
				guiNode.set_button_text(pauseButton, "Pause")
				current_state = PLAYING
				_set_music(PLAY)
		"About":
			guiNode.set_button_state("About", DISABLED)
func _slider_value_changed(value, slider_name) -> void:
	if slider_name == "MusicSlider":
		if current_state == PLAYING:
			if _is_music_on():
				print("Music on. Music Level:", value)
				_set_music(PLAY)
			else:
				_set_music(STOP)
	elif slider_name == "SoundSlider":
		if _is_sound_on():
			print("Sound on. Sound Level:", value)
		else:
			print("Sound off")
func _start_game() -> void:
	print("Game playing")
	current_state = PLAYING
	music_position = 0.0
	_set_music(PLAY)
	clear_grid()
	guiNode.reset_stats(guiNode.high_score)
	new_shape()
func _set_music(toggle) -> void:
	if toggle == PLAY:
		musicPlayerNode.volume_db = musicSlider.value
		if musicPlayerNode.playing == false:
			musicPlayerNode.play(music_position)
		print("Music started")
	else:
		music_position = musicPlayerNode.get_playback_position()
		musicPlayerNode.stop()
		print("Music stopped")
func _is_music_on() -> bool:
	return musicSlider.value > MIN_AUDIO_LEVEL
func _is_sound_on() -> bool:
	return soundSlider.value > MIN_AUDIO_LEVEL
func _game_over() -> void:
	timerNode.stop()
	guiNode.set_button_states(ENABLED)
	if _is_music_on():
		_set_music(STOP)
	current_state = STOPPED
	print("Game Stopped")
func clear_grid() -> void:
	grid_cell_occupied.clear()
	grid_cell_occupied.resize(guiNode.playAreaGrid.get_child_count())
	for i in grid_cell_occupied.size():
		grid_cell_occupied[i] = false
	guiNode.clear_all_cells()
func place_space(index: int, add_tiles: bool = false, is_locked: bool = false, color: Color = Color(0)) -> bool:
	var is_valid := true
	var current_shape_size := currentShapeData.coordinates.size()
	var current_shape_offset = currentShapeData.coordinates[0]
	var y = 0
	while y < current_shape_size and is_valid:
		for x in current_shape_size:
			if currentShapeData.grid[y][x]:
				var grid_position = index + (y + current_shape_offset) * number_of_columns + x + current_shape_offset
				if is_locked:
					grid_cell_occupied[grid_position] = true
				else:
					var column_x = index % number_of_columns + x + current_shape_offset
					if column_x < 0 or column_x >= number_of_columns or grid_position >= grid_cell_occupied.size() or grid_position >= 0 and grid_cell_occupied[grid_position]:
						is_valid = !is_valid
						break
					if add_tiles and grid_position >= 0:
						guiNode.playAreaGrid.get_child(grid_position).modulate = color
		y += 1
	return is_valid
func add_shape_to_grid() -> void:
	place_space(currentShapePosition, true, false, currentShapeData.color)
func remove_shape_from_grid() -> void:
	place_space(currentShapePosition, true)
func lock_shape_to_grid() -> void:
	place_space(currentShapePosition, false, true)
func rotate_shape(rotation_direction):
	match rotation_direction:
		LEFT:
			currentShapeData.rotate_left()
			rotation_direction = RIGHT
		RIGHT:
			currentShapeData.rotate_right()
			rotation_direction = LEFT
	return rotation_direction
func move_shape(new_position, rotation_direction = null) -> bool:
	remove_shape_from_grid()
	# rotate shape and store undo direction
	rotation_direction = rotate_shape(rotation_direction)
	# Check if the place then update the position, else undo rotation
	var is_placement_valid = place_space(new_position)
	if is_placement_valid:
		currentShapePosition = new_position
	else:
		rotate_shape(rotation_direction)
	add_shape_to_grid()
	return is_placement_valid
func update_high_score() -> void:
	if guiNode.score > guiNode.high_score:
		guiNode.high_score = guiNode.score
func update_current_score(cleared_lines):
	guiNode.lines += cleared_lines
	print("Cleared %d lines" % cleared_lines)
	var score = 10 * int(pow(2, cleared_lines - 1))
	print("Added %d to score" % score)
	guiNode.score += score
	update_high_score()
func new_shape() -> void:
	if nextShape:
		currentShapeData = nextShape
	else:
		currentShapeData = Shapes.get_shape()
	nextShape = Shapes.get_shape()
	guiNode.set_next_shape(nextShape)
	currentShapePosition = STARTING_SHAPE_POSITION
	add_shape_to_grid()
	normal_drop()
	level_up()
func normal_drop() -> void:
	timerNode.start(TICK_SPEED / guiNode.level)
func soft_drop() -> void:
	timerNode.stop()
	timerNode.start(TICK_SPEED / guiNode.level / SOFT_DROP_MULTIPLE)
func hard_drop() -> void:
	timerNode.stop()
	timerNode.start(TICK_SPEED / MAX_LEVEL)
func level_up() -> void:
	total_dropped_shapes += 1
	if total_dropped_shapes % 10 == 0:
		increase_level()
func increase_level() -> void:
	if guiNode.level < MAX_LEVEL:
		guiNode.level += 1
		timerNode.set_wait_time(TICK_SPEED / guiNode.level)
