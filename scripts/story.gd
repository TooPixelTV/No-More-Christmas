extends Node2D

@onready var story_text: Label = $CanvasLayer/StoryText

var story_lines: Array[String] = [
	'This has gone on long enough, Santa Claus struggles every year to make gifts, but he never receives anything in return.',
	'It is time for him to put an end to this tradition.',
	'Help Santa Claus destroy the gifts before the children reach them.',
	'If the joy gauge is filled to the maximum, the game ends.',
	'Try to hold out as long as possible.',
	'If you play with a Twitch chat, viewers can type "!x y" to spawn a gift as the x/y position.'
]

var current_line: int = 0

func _ready() -> void:
	set_text_line()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		if current_line < story_lines.size() - 1:
			current_line += 1
			set_text_line()
		else:
			get_tree().change_scene_to_file("res://scenes/game.tscn")
			GameManager.set_music(GameManager.game_music)
	
func set_text_line():
	story_text.text = story_lines[current_line]
