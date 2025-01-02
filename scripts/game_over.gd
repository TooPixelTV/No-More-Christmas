extends CanvasLayer

@onready var score_value: Label = $HBoxContainer/ScoreValue

func set_score(score: int):
	score_value.text = str(score)

func _on_restart_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	GameManager.start_game()
