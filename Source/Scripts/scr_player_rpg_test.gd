extends CharacterBody2D

#Vars
@onready 	var anim_spr: 	AnimatedSprite2D 	= $Sprite;
@export 	var walk_spd: 	int 				= 50;
@export		var run_spd: 	int					= walk_spd*2;
var sprint: bool = false;

#Create
func _ready() -> void: pass;

#Step - Phy
func _process(delta: float) -> void:
	
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
	
	move_and_slide();
