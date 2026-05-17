extends CharacterBody2D

#region - Vars

@onready var debug_label:	Label	= $"../UI/CanvasLayer/Debug";
@export var walk_max_spd: 	float 	= 100.0;
@export var walk_accel_spd:	float	= 20.0;
@export var walk_decel_spd:	float	= 10;
@export var run_max_spd: 	float	= walk_max_spd * 1.75;
@export var run_accel_spd: 	float	= walk_accel_spd * 1.75;
@export var run_decel_spd: 	float	= walk_decel_spd * 1.75;

@export var jump_vel: 		float 				= 200.0;
@onready var spr:			AnimatedSprite2D 	= $Sprite;
enum states {
	idle,
	walk, 
	run,
	jump, 
	fall };
var state: states = states.idle;

#endregion

#Step
func _physics_process(delta: float) -> void:
	state_machine(delta);

#region - Functions
func state_machine(delta):
	
	#Vars
	var dir := Input.get_axis("move_left","move_right");
	
	#States
	match(state):
		states.idle:
			
			#Debug
			debug_label.text = "Idle";
			
			#Init
			animate();
			
			#Apply Speed
			apply_gravity(delta);
			move_and_slide();
			
			#States
			if(Input.is_action_just_pressed("jump")):		state = states.jump; jump(delta);
			elif(dir and Input.is_action_pressed("shift")):	state = states.run;
			elif(dir):										state = states.walk;
			
			
		states.walk:
			
			#Debug
			debug_label.text = "Walk";
			
			#Init
			animate();
			
			#Move
			walk(dir);
			
			#Apply Speed
			apply_gravity(delta);
			move_and_slide();
			
			#States
			if(Input.is_action_just_pressed("jump")) && (is_on_floor()):		state = states.jump; jump(delta);
			elif(dir and Input.is_action_pressed("shift")):						state = states.run;
			elif(!dir) && (is_on_floor()): 										state = states.idle;
			
		states.run:
			
			#Debug
			debug_label.text = "Run";
			
			#Init
			animate();
			
			#Move
			run(dir);
			
			#Apply Speed
			apply_gravity(delta);
			move_and_slide();
			
			#States
			if(Input.is_action_just_pressed("jump")) && (is_on_floor()):		state = states.jump; jump(delta);		
			if(dir and Input.is_action_just_released("shift")):					state = states.walk;
			if(!dir) && (is_on_floor()): 										state = states.idle;		
			
		states.jump:
			
			#Debug
			debug_label.text = "Jump";
			
			#Init
			animate();
			
			#Apply Speed
			apply_gravity(delta);
			move_and_slide();
			
			#States
			await get_tree().create_timer(0.1).timeout;
			if(not is_on_floor()) && (velocity.y > 0): 				state = states.fall;
			else:
				if(dir and Input.is_action_just_released("shift")):	state = states.walk;
				else:												state = states.idle;
			
		states.fall: 	pass;

func apply_gravity(delta):
	if not is_on_floor(): velocity += get_gravity() * delta;
func walk(dir):
	if dir: velocity.x = dir * walk_max_spd;
	else: 	velocity.x = move_toward(velocity.x, 0, walk_max_spd);
func run(dir):
	if dir: velocity.x = dir * run_max_spd;
	else: 	velocity.x = move_toward(velocity.x, 0, run_max_spd);
func jump(delta): 
	velocity.y = -jump_vel;
func animate():
	if(velocity.x != 0):
		spr.play("Walk");
		if(velocity.x < 0):		spr.flip_h = true;
		elif(velocity.x > 0):	spr.flip_h = false;
	else:
		spr.play("Idle");
