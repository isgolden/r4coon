extends CharacterBody2D

enum State { ATTACK, DETECT, IDLE, HURT }

@export var stats : enemy_stats;
@export var behaviour: enemy_behaviour;
@export var debug_behaviour: bool = true;

var state: State = State.IDLE
var current_target: Node2D
var attack_direction: Vector2 = Vector2.ZERO
var _last_debug_message: String = ""

@onready var healthComp = $HealthComponent;
@onready var hurtBox := $HealthComponent/HurtboxComponent;
@onready var detectionShape: CollisionShape2D = $DetectionZone/CollisionShape2D;
@onready var attackRange: CollisionShape2D = $AttackRange/CollisionShape2D;

func _ready() -> void:
	healthComp.health = stats.max_health;
	# hurtBox.connect("area_entered",onHit) # this should be good
	set_detection_zone_radius()
	set_attack_range()


func set_detection_zone_radius() -> void:
	var circle_shape := detectionShape.shape as CircleShape2D
	if circle_shape == null:
		push_error("DetectionZone CollisionShape2D must use a CircleShape2D.")
		return

	circle_shape = circle_shape.duplicate() as CircleShape2D
	if circle_shape == null:
		push_error("Failed to duplicate the DetectionZone CircleShape2D.")
		return

	detectionShape.shape = circle_shape
	circle_shape.radius = maxf(stats.detection_zone, 0.0)

func set_attack_range() -> void:
	var circle_shape := attackRange.shape as CircleShape2D
	if circle_shape == null:
		push_error("Attack Range CollisionShape2D must use a CircleShape2D.")
		return

	circle_shape = circle_shape.duplicate() as CircleShape2D
	if circle_shape == null:
		push_error("Failed to duplicate the Attack Range CircleShape2D.")
		return

	attackRange.shape = circle_shape
	circle_shape.radius = maxf(stats.attack_range, 0.0)


func onHit(area: Area2D) -> void:
	var source: Node = area
	while source != null:
		if source.is_in_group(GroupNames.PLAYER):
			state = State.HURT
			current_target = source as Node2D
			return
		source = source.get_parent()


func clear_hurt_state() -> void:
	if state == State.HURT:
		state = State.IDLE


func _physics_process(_delta: float) -> void:
	if state != State.HURT:
		update_state()

	if behaviour == null:
		velocity = Vector2.ZERO
		attack_direction = Vector2.ZERO
		move_and_slide()
		return

	var directions := get_state_directions(_delta)
	log_behaviour_directions(directions)
	if directions.has_movement_direction:
		velocity = directions.movement_direction * stats.movement_speed
	else:
		velocity = Vector2.ZERO

	attack_direction = directions.attack_direction if directions.has_attack_direction else Vector2.ZERO
	move_and_slide()


func update_state() -> void:
	current_target = find_target_in_range(stats.attack_range)
	if current_target != null:
		state = State.ATTACK
		return

	current_target = find_target_in_range(stats.detection_zone)
	if current_target != null:
		state = State.DETECT
		return

	state = State.IDLE


func get_state_directions(delta: float) -> enemy_behaviour_directions:
	match state:
		State.ATTACK:
			return behaviour.attack(self, current_target, delta)
		State.DETECT:
			return behaviour.detect(self, current_target, delta)
		State.IDLE:
			return behaviour.idle(self, null, delta)
		State.HURT:
			return behaviour.hurt(self, current_target, delta)

	push_error("Enemy has an unsupported state.")
	return enemy_behaviour_directions.new()


func log_behaviour_directions(directions: enemy_behaviour_directions) -> void:
	if not debug_behaviour:
		return

	var target_name := str(current_target.name) if is_instance_valid(current_target) else "none"
	var movement := str(directions.movement_direction) if directions.has_movement_direction else "null"
	var attack := str(directions.attack_direction) if directions.has_attack_direction else "null"
	var message := "Enemy %s: state=%s target=%s movement=%s attack=%s" % [
		name,
		State.keys()[state],
		target_name,
		movement,
		attack,
	]
	if message != _last_debug_message:
		print(message)
		_last_debug_message = message


func find_target_in_range(target_range: float) -> Node2D:
	if stats == null:
		return null

	var range_squared := maxf(target_range, 0.0) ** 2
	var closest_target: Node2D = null
	var closest_distance_squared := INF

	for node in get_tree().get_nodes_in_group(GroupNames.PLAYER):
		var candidate := node as Node2D
		if candidate == null:
			continue

		var distance_squared := global_position.distance_squared_to(candidate.global_position)
		if distance_squared <= range_squared and distance_squared < closest_distance_squared:
			closest_distance_squared = distance_squared
			closest_target = candidate

	return closest_target
