extends enemy_behaviour
class_name enemy_behaviour_runner

func attack(
	owner_body: CharacterBody2D,
	target: Node2D,
	_delta: float
) -> enemy_behaviour_directions:
	var directions := enemy_behaviour_directions.new()
	if owner_body == null or target == null:
		return directions

	var to_target := target.global_position - owner_body.global_position
	if to_target.length_squared() > 0.0:
		directions.attack_direction = to_target.normalized()
		directions.has_attack_direction = true

	return directions


func detect(
	owner_body: CharacterBody2D,
	target: Node2D,
	_delta: float
) -> enemy_behaviour_directions:
	var directions := enemy_behaviour_directions.new()
	if owner_body == null or target == null:
		return directions

	var to_target := target.global_position - owner_body.global_position
	if to_target.length_squared() > 0.0:
		directions.movement_direction = to_target.normalized()
		directions.has_movement_direction = true

	return directions
