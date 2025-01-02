extends Node2D

@onready var child_start: Node = $ChildStart
@onready var children: Node = $Children
@onready var gifts: Node = $Gifts
@onready var timer_label: Label = $CanvasLayer/Timer/TimerLabel
@onready var gift_spawn_timer: Timer = $Timers/GiftSpawnTimer
@onready var game_timer: Timer = $Timers/GameTimer
@onready var game_over_screen: CanvasLayer = $GameOverScreen

const CHILD = preload("res://scenes/child.tscn")
const GIFT = preload("res://scenes/gift.tscn")

var current_time = 0

func _ready() -> void:
	connect_to_twitch()
	current_time = 0
	spawn_gift()
	spawn_new_child()
	game_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer_label.text = str(current_time)
	
	if GameManager.current_joy >= GameManager.max_joy:
		game_timer.stop()
		GameManager.current_joy = GameManager.max_joy
		get_tree().paused = true
		game_over_screen.set_score(current_time)
		game_over_screen.show()


func _on_child_spawn_timer_timeout() -> void:
	spawn_new_child()

func _on_gift_spawn_timer_timeout() -> void:
	spawn_gift()
	

func spawn_new_child() -> void:
	var spawn_marker = child_start.get_children().pick_random()
	
	var child: Child = CHILD.instantiate()
	child.position = spawn_marker.position
	
	children.add_child(child)


func spawn_gift() -> void:
	var spawn_area: SpawnArea = get_tree().get_first_node_in_group("spawn_area")
	
	var gift: Gift = GIFT.instantiate()
	gift.position = spawn_area.get_random_pos()
	
	gifts.add_child(gift)


func _on_game_timer_timeout() -> void:
	current_time += 1
	
	if current_time > 0 and current_time % 10 == 0:
		gift_spawn_timer.wait_time = gift_spawn_timer.wait_time * 0.85

func _on_twitch_message(data: Chatter) -> void:
	var message = data.message
	if message.begins_with("!"):
		message = message.substr(1)
		var split_mes = message.split(" ")
		
		if split_mes.size() == 2:
			var pos_x: float = clamp(split_mes[0].to_float(), 0, 100)
			var pos_y: float = clamp(split_mes[1].to_float(), 0, 100)
			
			var spawn_area: SpawnArea = get_tree().get_first_node_in_group("spawn_area")
			
			var gift: Gift = GIFT.instantiate()
			gift.position = spawn_area.get_percent_pos(pos_x, pos_y)
	
			gifts.add_child(gift)

func connect_to_twitch() -> void:
	if GameManager.twitch_channel.strip_edges().length() > 0:
		VerySimpleTwitch.login_chat_anon(GameManager.twitch_channel)
		VerySimpleTwitch.chat_message_received.connect(_on_twitch_message)
