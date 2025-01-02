extends CharacterBody2D
class_name Child

@export var speed: int = 250
@export var sprite_list: Array[Texture2D] = []

@onready var child_sprite: Sprite2D = $ChildSprite

var target_position: Vector2
var target_is_gift: bool = false
var current_gift: Gift = null

func _ready() -> void:
	if sprite_list.size() > 0:
		var rnd_sprite: Texture2D = sprite_list.pick_random()
		child_sprite.texture = rnd_sprite
	
	define_target(Vector2(200, 200), false)

func  _process(delta: float) -> void:
	if target_position != null:
		if not target_is_gift:
			find_target()
		else:
			if current_gift == null or not is_instance_valid(current_gift):
				target_position = position
				find_target()
			
			
		if position.distance_to(target_position) > 10:
			var direction = (target_position - position).normalized()
			velocity = direction * speed
		else:
			if target_is_gift and current_gift != null and is_instance_valid(current_gift):
				current_gift.child_pick_gift();
			
			velocity = Vector2.ZERO
			target_is_gift = false
			find_target()
	
	move_and_slide()


func define_target(_position: Vector2, is_gift: bool):
	target_position = _position
	target_is_gift = is_gift

func find_target() -> void:
	var gifts = get_tree().get_nodes_in_group("gift")
	gifts = gifts.filter(func(g): return g.pickable and not g.is_targeted)
	
	if gifts.size() > 0:
		var gift = null
		var distance = INF
		for gift_element in gifts:
			if position.distance_to(gift_element.position) < distance:
				distance = position.distance_to(gift_element.position)
				gift = gift_element
				gift.is_targeted = true
		
		if gift != null:
			current_gift = gift
			define_target(gift.position, true)
	else:
		if position.distance_to(target_position) < 10:
			var spawn_area: SpawnArea = get_tree().get_first_node_in_group("spawn_area")
			define_target(spawn_area.get_random_pos(), false)
	
		
