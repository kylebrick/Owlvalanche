extends Node

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("debug_01")): get_tree().change_scene_to_file("res://Levels/00 - Testing/scn_000a_Diorama.tscn");
	if(Input.is_action_just_pressed("debug_02")): get_tree().change_scene_to_file("res://Levels/00 - Testing/scn_000b_Sidescroller.tscn");
	if(Input.is_action_just_pressed("debug_03")): get_tree().change_scene_to_file("res://Levels/00 - Testing/scn_000c_RPG.tscn");
	if(Input.is_action_just_pressed("debug_04")): get_tree().change_scene_to_file("res://Levels/00 - Testing/scn_000d_Platformer.tscn");
