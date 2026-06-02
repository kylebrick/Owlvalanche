extends Area2D

signal sig_pressed;
signal sig_released;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Blocks")):
		if($AnimSprite.animation != "Pushed"):
			$AnimSprite.play("Pushed");
		$SFXButton.play();
		sig_pressed.emit();

func _on_body_exited(body: Node2D) -> void:
	if(body.is_in_group("Blocks")):
		if($AnimSprite.animation != "Release"):
			$AnimSprite.play("Release");
		$SFXButton.play();
		sig_released.emit();
