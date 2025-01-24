extends Node

enum {
	STOPPED,
	PLAYING,
	PAUSED,
	STOP,
	PLAY,
	PAUSE
 }

@onready var guiNode := get_node("GUI")
@onready var musicPlayerNode := get_node("AudioStream")
var current_state = STOPPED
var music_position = 0.0
var pauseButton: BaseButton
var playButton: BaseButton
var musicSlider: HSlider
var soundSlider: HSlider
var MIN_AUDIO_LEVEL

const ENABLED: bool = false
const DISABLED: bool = true

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
			if value > MIN_AUDIO_LEVEL:
				print("Music on. Music Level:", value)
				_set_music(PLAY)
			else:
				_set_music(STOP)
	elif slider_name == "SoundSlider":
		if value > MIN_AUDIO_LEVEL:
			print("Sound on. Sound Level:", value)
		else:
			print("Sound off")


func _start_game() -> void:
	print("Game playing")
	current_state = PLAYING
	music_position = 0.0
	_set_music(PLAY)

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
	
	
func _game_over():
	guiNode.set_button_states(ENABLED)
	if _is_music_on():
		_set_music(STOP)
	current_state = STOPPED
	print("Game Stopped")
