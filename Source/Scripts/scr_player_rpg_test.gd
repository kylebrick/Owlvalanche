extends CharacterBody2D
class_name Player

#Vars
@onready 	var anim_spr: 	AnimatedSprite2D 	= $Sprite;
@onready	var shad_spr: 	Sprite2D			= $Shadow;

@export 	var walk_spd: 	int 				= 50;
@export		var push_str:	int					= 80;
@export		var jump_spd:	int					= 105;
@export		var grav:		int					= 300;
var run_spd: 				int					= walk_spd*2;
var sprint: 				bool 				= false;
var z_pos:					float				= 0.0;
var z_vel:					float				= 0.0;
var jumping:				bool				= false;
var double_jumping:			bool				= false;
var landed:					bool				= false;

#Create
func _ready() -> void: 
	position = Director.pl_spawn_pos;
	if(shad_spr.visible == true): shad_spr.visible = false;

#Step
func _physics_process(delta: float) -> void:
	
	#Walk / Run
	var dir := Input.get_vector("move_left","move_right","move_up","move_down");
	var move_spd;
	if(Input.is_action_pressed("shift")): 	move_spd = run_spd;
	else:									move_spd = walk_spd;
	velocity = dir * move_spd;
	
	#Jump & Double Jump
	if(Input.is_action_just_pressed("jump")) && (!jumping):
		z_vel = jump_spd; jumping = true; 
		shad_spr.visible = true;
	elif(Input.is_action_just_pressed("jump")) && (jumping) && (!double_jumping):
		z_vel = jump_spd; double_jumping = true;
	
	#Apply Gravity
	if(jumping):
		z_vel -= grav * delta;
		z_pos += z_vel * delta;
		if(z_pos <= 0.0):
			z_pos = 0.0;
			z_vel = 0.0;
			jumping = false;
			double_jumping = false;
			shad_spr.visible = false;
			anim_spr.play("walk_down");
			
	#Offset Sprite w/ Jump
	anim_spr.position.y = -z_pos;
	
	#Shrink Shadow w/ Distance
	var shad_scale = clamp(1.0-(z_pos/80.0),0.4,1.0);
	shad_spr.scale = Vector2(shad_scale,shad_scale);
	shad_spr.modulate.a = shad_scale;
	
	#Animation
	if(!jumping):
		if	(velocity.x < 0): anim_spr.play("walk_right"); anim_spr.flip_h = true;
		elif(velocity.x > 0): anim_spr.play("walk_right"); anim_spr.flip_h = false;
		elif(velocity.y > 0): anim_spr.play("walk_down");	anim_spr.flip_h = false;
		elif(velocity.y < 0): anim_spr.play("walk_up");	anim_spr.flip_h = false;
		elif(velocity == Vector2.ZERO):
			anim_spr.stop(); anim_spr.frame = 0;
	else:
		anim_spr.play("jump");
		anim_spr.frame = 0;
	
	#Check last collision
	#If it's the block... push it.
	var col: KinematicCollision2D = get_last_slide_collision();
	if(col != null):
		var col_node = col.get_collider(); #Get block node ID
		if(col_node.is_in_group("Blocks")):
			var col_norm: Vector2 = col.get_normal();
			col_node.apply_central_force(-col_norm*push_str);
	
	move_and_slide();
