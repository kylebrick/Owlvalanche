extends CharacterBody2D

#Vars
@onready 	var anim_spr: AnimatedSprite2D 	= $Sprite;
@export 	var move_spd: int 				= 50;

#Create
func _ready() -> void: pass;

#Step - Phy
func _process(delta: float) -> void:
	
	#Move
	var dir := Input.get_vector("move_left","move_right","move_up","move_down");
	velocity = dir * move_spd;
	
	#Animation
	if	(velocity.x > 0): anim_spr.play("walk_right");
	elif(velocity.x < 0): anim_spr.play("walk_left");
	elif(velocity.y > 0): anim_spr.play("walk_down");
	elif(velocity.y < 0): anim_spr.play("walk_up");
	elif(velocity == Vector2.ZERO):
		anim_spr.stop(); anim_spr.frame = 0;
	
	move_and_slide();
