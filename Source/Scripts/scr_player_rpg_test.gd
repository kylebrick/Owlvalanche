extends CharacterBody2D
class_name Player

#Vars
@onready 	var anim_spr: 	AnimatedSprite2D 	= $Sprite;
@export 	var walk_spd: 	int 				= 50;
@export		var push_str:	int					= 80;
var run_spd: 				int					= walk_spd*2;
var sprint: 				bool 				= false;

#Create
func _ready() -> void:
	position = Director.pl_spawn_pos;
	#Engine.max_fps = 15;

#Step
func _physics_process(delta: float) -> void:
	
	#Walk / Run
	var dir := Input.get_vector("move_left","move_right","move_up","move_down");
	var move_spd;
	if(Input.is_action_pressed("shift")): 	move_spd = run_spd;
	else:									move_spd = walk_spd;
	velocity = dir * move_spd;
	
	#Animation
	if	(velocity.x > 0): anim_spr.play("walk_right");
	elif(velocity.x < 0): anim_spr.play("walk_left");
	elif(velocity.y > 0): anim_spr.play("walk_down");
	elif(velocity.y < 0): anim_spr.play("walk_up");
	elif(velocity == Vector2.ZERO):
		anim_spr.stop(); anim_spr.frame = 0;
	
	#Check last collision
	#If it's the block... push it.
	var col: KinematicCollision2D = get_last_slide_collision();
	if(col != null):
		var col_node = col.get_collider(); #Get block node ID
		if(col_node.is_in_group("Blocks")):
			var col_norm: Vector2 = col.get_normal();
			col_node.apply_central_force(-col_norm*push_str);
	
	move_and_slide();
