extends Control

@onready var progress_bar: ProgressBar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar.max_value = GameManager.max_joy


func _process(delta: float) -> void:
	progress_bar.value = GameManager.current_joy
