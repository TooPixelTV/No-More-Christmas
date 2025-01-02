extends StaticBody2D
class_name Gift

@export var sprite_list: Array[Texture2D] = []

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var explosion: CPUParticles2D = $Explosion
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sound_effect: AudioStreamPlayer = $SoundEffect

var is_picked: bool = false
var pickable: bool = false
var is_targeted: bool = false

var destroy_sounds = [
	"res://assets/audios/Rock Dirt Impact Dull A.wav", 
	"res://assets/audios/Rock Dirt Impact Dull B.wav", 
	"res://assets/audios/Rock Dirt Impact Dull C.wav", 
	"res://assets/audios/Rock Dirt Impact Dull D.wav", 
	"res://assets/audios/Rock Dirt Impact Dull E.wav"
]

var pick_sound = preload("res://assets/audios/sound.wav")

func _ready() -> void:
	if sprite_list.size() > 0:
		var rnd_sprite = sprite_list.pick_random()
		sprite_2d.texture = rnd_sprite
	
	animation_player.play("spawn")
	await get_tree().create_timer(1.5).timeout
	animation_player.stop()
	pickable = true

func child_pick_gift():
	if not is_picked:
		is_picked = true
		GameManager.gift_picked()
		collision_shape_2d.disabled = true
		create_tween().tween_property(sprite_2d, "modulate:a", 0, 0.1).finished
		
		sound_effect.stream = pick_sound
		sound_effect.play()
		await sound_effect.finished
		
		queue_free()


func destroy_gift():
	animation_player.stop()
	is_picked = true
	
	collision_shape_2d.call_deferred("disabled", true)
	create_tween().tween_property(sprite_2d, "modulate:a", 0, 0.1)
	
	explosion.emitting = true
	
	var audio_file = load(destroy_sounds.pick_random())
	sound_effect.stream = audio_file
	sound_effect.play()
	
	await explosion.finished
	queue_free()
