extends Area2D

@export var next_scn: String;
@export var pl_spawn_pos: Vector2;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if(body is Player): 
		Director.pl_spawn_pos = pl_spawn_pos;
		get_tree().change_scene_to_file.call_deferred(next_scn);
