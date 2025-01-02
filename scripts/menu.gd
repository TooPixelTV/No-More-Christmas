extends CanvasLayer

@onready var twitch_channel_input: TextEdit = $HBoxContainer/TwitchChannelInput

func _on_start_button_pressed() -> void:
	GameManager.twitch_channel = twitch_channel_input.text
	get_tree().change_scene_to_file("res://scenes/story.tscn")
