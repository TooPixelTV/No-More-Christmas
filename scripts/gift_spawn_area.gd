extends Area2D
class_name SpawnArea

@onready var gift_spawn_area: CollisionShape2D = $CollisionShape2D

func get_random_pos() -> Vector2:
	var rect = gift_spawn_area.shape.get_rect()
	
	var min_x = rect.position.x
	var max_x = min_x + rect.size.x
	
	var min_y = rect.position.y
	var max_y = min_y + rect.size.y
	
	var rnd_x = randf_range(min_x, max_x)
	var rnd_y = randf_range(min_y, max_y)
	
	return Vector2(rnd_x, rnd_y)

func get_percent_pos(x: float, y: float) -> Vector2:
	var rect = gift_spawn_area.shape.get_rect()
	
	var min_x = rect.position.x
	var max_x = min_x + rect.size.x
	
	var x_value = min_x + (max_x - min_x) * (x / 100.0)
	
	var min_y = rect.position.y
	var max_y = min_y + rect.size.y
	
	var y_value = min_y + (max_y - min_y) * (y / 100.0)
	
	return Vector2(x_value, y_value)
