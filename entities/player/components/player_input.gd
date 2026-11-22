class_name input_handler

@export var pStats : player_stats

@export var mVec : Vector2 = Vector2(0,0);
# i assume what yall want here is an input of player stats and an 
# output of movment vectors? a little confused on why player and 
# player_input are different scripts

var dis = 0;

func handle_input() -> void:
	if not Input.is_anything_pressed():
		return
	mVec.y = int(Input.is_action_pressed("down"))-int(Input.is_action_pressed("up"));
	mVec.x = int(Input.is_action_pressed("right"))-int(Input.is_action_pressed("left"));
	print(mVec);
	if(mVec.y == 0 and mVec.x == 0):
		return
	dis = sqrt(mVec.x*mVec.x+mVec.y*mVec.y); # not predividing in case we ever need dis in the future
	mVec.x /= dis;
	mVec.y /= dis;
	if pStats:
		mVec *= pStats.mvSpeed;
	else:
		push_error("player stats undefined in input handeler")
