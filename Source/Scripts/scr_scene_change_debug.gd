extends Node

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("debug_01")): get_tree().change_scene_to_file("res://Levels/00 - Testing/scn_000a_diorama.tscn");
	if(Input.is_action_just_pressed("debug_02")): get_tree().change_scene_to_file("res://Levels/00 - Testing/scn_000b_sidescroller.tscn");
	if(Input.is_action_just_pressed("debug_03")): get_tree().change_scene_to_file("res://Levels/00 - Testing/scn_000c_rpg.tscn");
	if(Input.is_action_just_pressed("debug_04")): get_tree().change_scene_to_file("res://Levels/00 - Testing/scn_000d_platformer.tscn");
