extends CharacterBody2D

@export var stats : enemy_stats;

@onready var healthComp = $HealthComponent;
@onready var hurtBox := $HealthComponent/HurtboxComponent;

func _ready() -> void:
	healthComp.health = stats.max_health;
	hurtBox.connect("area_entered",onHit) # this should be good

func onHit() -> void:
	pass
