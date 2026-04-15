extends CharacterBody2D

#Vars
@export var walk_accel: 	float 	= 400.0;
@export var walk_frict: 	float 	= 300.0;
@export var shoe_step_spd: 	float 	= 150.0;
@export var shoe_step_time: float 	= 0.185;
@export var board_accel: 	float 	= 200.0;
@export var board_frict: 	float 	= 80.55;
@export var board_turn_spd: float 	= 2.555;
@export var move_spd: 		float 	= 100.0;
var dir: 				Vector2 = Vector2.ZERO;

#Step - Phy
func _physics_process(delta: float) -> void:
	
	#Move
	_move_skiing(delta);
	move_and_slide();

func _move_neutral(): 	pass;
func _move_snowshoes(): pass;
func _move_snowboard(): pass;
func _move_skiing(delta):
	var dir := Input.get_vector("move_left","move_right","move_up","move_down");
	if(dir != Vector2.ZERO):
		if(abs(dir.x) >= abs(dir.y)): 	dir = Vector2(sign(dir.x),0);
		else: 							dir = Vector2(0,sign(dir.y));
		velocity = dir*move_spd;
	else:
		velocity = velocity.move_toward(Vector2.ZERO,move_spd*delta);
