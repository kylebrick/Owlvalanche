extends CharacterBody2D

#region - Vars

@onready var spr:					AnimatedSprite2D 	= $SpritePivot/Sprite;
@onready var anim:					AnimationPlayer		= $Anim;
@onready var coyote_timer:			Timer				= $CoyoteTime;
@onready var fx_footsteps:			CPUParticles2D		= $FXFootsteps;

@export var sfx_jump:				AudioStreamPlayer;
@export var sfx_wings:				AudioStreamPlayer;
@export var sfx_walk:				AudioStreamPlayer; 
@export var sfx_crouch:				AudioStreamPlayer; 
@export var sfx_super_crouch:		AudioStreamPlayer;

@onready var debug_label:		Label	= $"../UI/CanvasLayer/Debug";
@export var walk_max_spd: 		float 	= 100.0;
@export var walk_accel_spd:		float	= 20.0;
@export var walk_decel_spd:		float	= 10;
@export var jump_vel: 			float 	= 200.0;
@export var double_jump_vel: 	float	= jump_vel*0.85;
@export var coyote_time_count:	float	= 0.1;
var fx_footsteps_offset:		float	= 7;
var run_max_spd: 				float	= walk_max_spd * 1.75;
var run_accel_spd: 				float	= walk_accel_spd * 1.75;
var run_decel_spd: 				float	= walk_decel_spd * 1.75;
var can_double_jump: 			bool	= true;
var can_coyote_jump:			bool 	= true;
var grounded:					bool	= false;
var landed:						bool	= false;
var crouched:					bool	= false;
var sup_crouch:					bool	= false;
var footstep:					bool	= false;
var jump_init:					bool 	= false;

enum states {
	idle,
	walk, 
	run,
	jump, 
	fall };
var state: 					states 	= states.idle;

#endregion

#Create
func _ready() -> void:
	coyote_timer.wait_time = coyote_time_count;

#Step
func _physics_process(delta: float) -> void:
	
	#Vars
	var dir := Input.get_axis("move_left","move_right");
	
	#Grounded
	if(is_on_floor()):
		
		#Init
		if(!landed):
			landed = true;
			jump_init = false;
			can_double_jump = true;
			can_coyote_jump = true;
			crouch_reset();
		
		#Walk & Run
		if(Input.is_action_pressed("shift")): 		run(dir);
		else:										walk(dir);
		
		#FX
		if(dir): 	footsteps(footstep);
		else:		fx_footsteps.emitting = false;		
		
		#Jump
		if(Input.is_action_just_pressed("jump")): sfx_jump.play(); jump();
			
		#Crouch
		if(Input.is_action_pressed("move_down")) && (Input.is_action_pressed("shift")):
			super_crouch();
		elif(Input.is_action_pressed("move_down")) && (Input.is_action_just_released("shift")) && (sup_crouch):
			crouched = false; sup_crouch = false; crouch();
		elif(Input.is_action_pressed("move_down")):
			crouch();
		elif(Input.is_action_just_released("move_down")):
			crouch_reset();
	elif(not is_on_floor()):
		
		#Init
		if(!jump_init):
			get_tree().create_timer(0.1).timeout;
			anim.stop(); anim.play("Jump");
			crouched = false; sup_crouch = false;
			jump_init = true; landed = false;
			fx_footsteps.emitting = false;
			coyote_timer.start();

		#Walk & Run
		if(Input.is_action_pressed("shift")): 		run(dir);
		else:										walk(dir);

		#Coyote Jump
		if(can_coyote_jump):
			if(Input.is_action_just_pressed("jump")): 
				sfx_jump.play(); jump();
				can_coyote_jump = false;
		else:
			#Double Jump
			if(Input.is_action_just_pressed("jump")) && (can_double_jump):
				velocity.y = 0.0; anim.play("Jump"); double_jump();

	#Misc.
	apply_gravity(delta);
	move_and_slide();
	animate();
	
	#DEBUG
	if(Input.is_action_just_pressed("restart")): get_tree().reload_current_scene();

#region - Functions

func apply_gravity(delta):
	if not is_on_floor(): velocity += get_gravity() * delta;
func walk(dir):
	if dir: velocity.x = dir * walk_max_spd;
	else: 	velocity.x = move_toward(velocity.x, 0, walk_max_spd);
func run(dir):
	if dir: velocity.x = dir * run_max_spd;
	else: 	velocity.x = move_toward(velocity.x, 0, run_max_spd);
func jump():
	crouched = false;
	sup_crouch = false;
	velocity.y = -jump_vel;
func crouch():
	if(!crouched):
		anim.stop();
		anim.play("Crouch");
		sfx_crouch.play();
		crouched = true;
func super_crouch():
	if(!sup_crouch):
		anim.stop();
		anim.play("Super Crouch");
		sfx_super_crouch.play();
		sup_crouch = true;
func crouch_reset():
	anim.stop();
	anim.play("Idle");
	crouched = false;
	sup_crouch = false;	
func double_jump():
	sfx_wings.set_pitch_scale(randf_range(0.95,1.05));
	sfx_wings.play();
	can_double_jump = false;
	velocity.y = -double_jump_vel;
func animate():

	#Move & Jump
	if(is_on_floor()):
		if(velocity.x != 0) && (not Input.is_action_pressed("shift")): 	spr.play("Walk"); spr.speed_scale = 1;
		elif(velocity.x != 0) && (Input.is_action_pressed("shift")): 	spr.play("Walk"); spr.speed_scale = 1.2;
		else:					spr.play("Idle"); spr.speed_scale = 1;
	elif(not is_on_floor()):
		if(velocity.y < 0):		spr.play("Jump"); spr.speed_scale = 1;
		else:					spr.play("Fall"); spr.speed_scale = 1;

	#Flip
	if(velocity.x < 0):
		spr.flip_h = true;
		fx_footsteps.position.x =  fx_footsteps_offset;
	elif(velocity.x > 0):
		spr.flip_h = false;
		fx_footsteps.position.x = -fx_footsteps_offset;
func footsteps(toggle):
	
	if(!toggle):
		if(spr.frame == 2) or (spr.frame == 5):			
			if(!sup_crouch): 	sfx_walk.set_pitch_scale(randf_range(0.95,1.05));
			else:				sfx_walk.set_pitch_scale(randf_range(1.55,1.65));
			sfx_walk.play(); fx_footsteps.emitting = true;
			
			footstep = true;
	elif(toggle):
		if(spr.frame == 1) or (spr.frame == 3):
			footstep = false;
func _on_coyote_time_timeout() -> void:
	can_coyote_jump = false;

#endregion
