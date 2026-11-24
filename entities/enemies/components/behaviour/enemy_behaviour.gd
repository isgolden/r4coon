extends Resource
class_name enemy_behaviour


func attack(
	_owner_body: CharacterBody2D,
	_target: Node2D,
	_delta: float
) -> enemy_behaviour_directions:
	return enemy_behaviour_directions.new()


func detect(
	_owner_body: CharacterBody2D,
	_target: Node2D,
	_delta: float
) -> enemy_behaviour_directions:
	return enemy_behaviour_directions.new()


func idle(
	_owner_body: CharacterBody2D,
	_target: Node2D,
	_delta: float
) -> enemy_behaviour_directions:
	return enemy_behaviour_directions.new()


func hurt(
	_owner_body: CharacterBody2D,
	_target: Node2D,
	_delta: float
) -> enemy_behaviour_directions:
	return enemy_behaviour_directions.new()
