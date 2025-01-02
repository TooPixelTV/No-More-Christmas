extends CharacterBody2D

@export var speed: int = 400
@export var attack_angle: float = 45

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var weapon: Area2D = $Weapon
@onready var weapon_collision: CollisionShape2D = $Weapon/CollisionShape2D
@onready var sound_effect: AudioStreamPlayer = $SoundEffect

var can_attack: bool = true
var last_direction: Vector2 = Vector2.ZERO

var attack_sounds = [
	"res://assets/audios/Whoosh Fast A.wav",
	"res://assets/audios/Whoosh Fast B.wav",
	"res://assets/audios/Whoosh Fast C.wav",
	"res://assets/audios/Whoosh Fast D.wav"
]

func _ready() -> void:
	weapon_collision.disabled = true

func _process(delta: float) -> void:
	var direction_horizontal = Input.get_axis("move_left", "move_right")
	var direction_vertical = Input.get_axis("move_up", "move_down")
	
	var direction = Vector2(direction_horizontal, direction_vertical).normalized()
	
	if direction != Vector2.ZERO:
		last_direction = direction
	
	handle_attack()
	handle_anims(direction)
	
	velocity = direction * speed
	
	move_and_slide()

func handle_attack():
	if can_attack and Input.is_action_just_pressed("attack"):
		can_attack = false
		weapon_collision.disabled = false
		weapon.show()
		
		var sound = load(attack_sounds.pick_random())
		sound_effect.stream = sound
		sound_effect.play()
		
		var angle = rad_to_deg(last_direction.angle())
		var angle_min = angle - attack_angle
		var angle_max = angle + attack_angle
		
		weapon.rotation_degrees = angle_min
		
		await create_tween().tween_property(weapon, "rotation_degrees", angle_max, 0.2).finished
		
		can_attack = true
		weapon_collision.disabled = true
		weapon.hide()
		
		


func handle_anims(direction: Vector2):
	if direction != Vector2.ZERO:
		if animation_player.current_animation != "walk":
			animation_player.play("RESET")
		animation_player.play("walk")
	else:
		if animation_player.current_animation != "idle":
			animation_player.play("RESET")
		animation_player.play("idle")


func _on_weapon_body_entered(body: Node2D) -> void:
	if body.is_in_group("gift"):
		body.destroy_gift()
