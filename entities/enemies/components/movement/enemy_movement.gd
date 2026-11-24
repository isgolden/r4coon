extends Resource
class_name enemy_movement


func get_movement_direction(_owner_body: CharacterBody2D) -> Vector2:
	push_error("enemy_movement.get_movement_direction() must be implemented by a subclass.")
	return Vector2.ZERO
