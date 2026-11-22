extends CharacterBody2D

const inputHandler := preload("res://entities/player/components/player_input.gd");
var handleInp : input_handler = inputHandler.new();


@export var stats : player_stats;

func _ready():
	handleInp.pStats = stats;

func _physics_process(delta: float) -> void:
	velocity = handleInp.mVec*delta*1000;
	move_and_slide(); # temp, unless its all we need
	
func _process(delta: float) -> void:
	#because the player input script isnt attatched to a node, none of the functions actually run.
	#doing this little hacky thing until i remeber to bring it up.
	handleInp.handle_input();
