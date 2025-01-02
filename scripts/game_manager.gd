extends Node

@export var max_joy: float = 100
@export var joy_per_gift: float = 10

var twitch_channel: String = ""

var current_joy: float = 0
var music: AudioStreamPlayer = AudioStreamPlayer.new()

var menu_music = "res://assets/audios/Jazz Vol2 Thoughtful Sunday Main.wav"
var game_music = "res://assets/audios/ActionFlick Spec Ops Main.wav"

func _ready() -> void:
	music.autoplay = true
	music.finished.connect(_on_music_end)
	set_music(menu_music)
	add_child(music)
	
func set_music(music_path: String):
	music.stop()
	var audio_file = load(music_path)
	
	music.stream = audio_file
	music.play(0)


func start_game(): 
	current_joy = 0


func gift_picked():
	current_joy += joy_per_gift


func _on_music_end():
	music.play(0)
