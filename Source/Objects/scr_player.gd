extends CharacterBody2D

#Nodes
@onready var sprite: 		Sprite2D			= $SpritePivot/Sprite;

#Vars
@export var walk_spd: 		float 				= 50.0;
@export var walk_accel: 	float 				= 1000.0;
@export var walk_frict: 	float 				= 500.0;
@export var shoe_step_spd: 	float 				= 150.0;
@export var shoe_step_time: float 				= 0.185;
@export var board_accel: 	float 				= 200.0;
@export var board_frict: 	float 				= 80.55;
@export var board_turn_spd: float 				= 2.555;
@export var move_spd: 		float 				= 100.0;
var shoe_step_timer: 		float 				= 0.0;
var shoe_stepping:			bool 				= false;
var board_angle:			float				= 0.0; #radians;

#Debug
var state: 					int					= 0;
var spr_walk: 				CompressedTexture2D = preload("res://Sprites/spr_owl.png");
var spr_board: 				CompressedTexture2D = preload("res://Sprites/spr_owl_board.png");
var spr_jump: 				CompressedTexture2D = preload("res://Sprites/spr_owl_jump.png");
var spr_shoes: 				CompressedTexture2D = preload("res://Sprites/spr_owl_shoes.png");
var spr_skiis: 				CompressedTexture2D = preload("res://Sprites/spr_owl_skiis.png");

#Step - Physics
func _physics_process(delta: float) -> void:

	#Move
	match state:
		0: move_neutral(delta); 	sprite.texture = spr_walk;
		1: move_snowshoes(delta); 	sprite.texture = spr_shoes;
		2: move_skiing(delta); 		sprite.texture = spr_skiis;
		3: move_snowboard(delta); 	sprite.texture = spr_board;
	move_and_slide();
	debug();

func debug():
	if		(Input.is_action_just_pressed("debug_01")): velocity = Vector2.ZERO; state = 0;
	elif	(Input.is_action_just_pressed("debug_02")): velocity = Vector2.ZERO; state = 1;
	elif	(Input.is_action_just_pressed("debug_03")): velocity = Vector2.ZERO; state = 2;
	elif	(Input.is_action_just_pressed("debug_04")): velocity = Vector2.ZERO; state = 3;
	
func move_neutral(delta: float) -> void:
	var dir := Input.get_vector("move_left","move_right","move_up","move_down");
	if(dir != Vector2.ZERO): 	velocity = velocity.move_toward(dir.normalized()*walk_spd,walk_accel*delta);
	else:						velocity = velocity.move_toward(Vector2.ZERO	*walk_spd,walk_frict*delta);
	
func move_snowshoes(delta: float) -> void:
	
	pass;
func move_snowboard(delta: float) -> void:
	
	pass;
func move_skiing(delta: float) -> void:
	var dir := Input.get_vector("move_left","move_right","move_up","move_down");
	if(dir != Vector2.ZERO):
		if(abs(dir.x) >= abs(dir.y)): 	dir = Vector2(sign(dir.x),0);
		else: 							dir = Vector2(0,sign(dir.y));
		velocity = dir*move_spd;
	else:
		velocity = velocity.move_toward(Vector2.ZERO,move_spd*delta);
