extends Node

#----

#Vars.
var pl_spawn_pos: Vector2 = Vector2(-527.0,-34.0);
var button_pressed: bool = false;

#Create
func _ready() -> void: pass;

#Step
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("restart")):
		get_tree().reload_current_scene();
		
#----
