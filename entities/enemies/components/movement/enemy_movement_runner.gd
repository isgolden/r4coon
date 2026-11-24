extends enemy_movement
class_name enemy_movement_runner

@export var movement_direction: Vector2 = Vector2.ZERO
@export var player_group: StringName = GroupNames.PLAYER


func get_movement_direction(owner_body: CharacterBody2D) -> Vector2:
	if owner_body == null:
		movement_direction = Vector2.ZERO
		return movement_direction

	var closest_player := find_closest_player(owner_body)
	if closest_player == null:
		movement_direction = Vector2.ZERO
		return movement_direction

	var to_player := closest_player.global_position - owner_body.global_position
	movement_direction = to_player.normalized() if to_player.length_squared() > 0.0 else Vector2.ZERO
	return movement_direction


func find_closest_player(owner_body: CharacterBody2D) -> Node2D:
	var closest_player: Node2D = null
	var closest_distance_squared := INF

	for node in owner_body.get_tree().get_nodes_in_group(player_group):
		var candidate := node as Node2D
		if candidate == null:
			continue

		var distance_squared := owner_body.global_position.distance_squared_to(candidate.global_position)
		if distance_squared < closest_distance_squared:
			closest_distance_squared = distance_squared
			closest_player = candidate

	return closest_player
