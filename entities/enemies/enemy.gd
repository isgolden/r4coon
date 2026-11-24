extends CharacterBody2D

@export var stats : enemy_stats;
@export var movement: enemy_movement;
@export var movement_script: Script;

@onready var healthComp = $HealthComponent;
@onready var hurtBox := $HealthComponent/HurtboxComponent;

func _ready() -> void:
	healthComp.health = stats.max_health;
	hurtBox.connect("area_entered",onHit) # this should be good

	if movement == null and movement_script != null:
		var instance = movement_script.new()
		if instance is enemy_movement:
			movement = instance
		else:
			push_error("movement_script must inherit enemy_movement")

func onHit() -> void:
	pass


func _physics_process(_delta: float) -> void:
	if movement == null:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var movement_direction := movement.get_movement_direction(self)
	velocity = movement_direction * stats.mvSpeed
	move_and_slide()
