extends StaticBody2D

func _on_button_sig_pressed() -> void:
	$Collision.set_deferred("disabled",true);
	visible = false; print("button pressed");
	
func _on_button_sig_released() -> void:
	$Collision.set_deferred("disabled",false);
	visible = true; print("button released");
