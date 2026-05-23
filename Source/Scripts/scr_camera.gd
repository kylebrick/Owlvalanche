extends Camera2D

@export var target: 	Node2D;
@export var cam_spd: 	int 	= 4;
@export var pos_smooth:	bool 	= false;

func _physics_process(delta):
	if(target):
		var targ_pos = target.position;
		
		#Smooth
		if(pos_smooth):	global_position = lerp(global_position,targ_pos,cam_spd*delta).round();
		else:			global_position = targ_pos.round();
