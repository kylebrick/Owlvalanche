extends Sprite2D

#----

#Vars.
#var default: bool = true;

#Create
func _ready() -> void:
	print("Hello, there! Radtastic day, huh?");

#Step
func _process(delta: float) -> void:
	position.x += 1;
	#position.y += 1;
	#scale += Vector2(0.1,0.1);

func _physics_process(delta: float) -> void: pass;

#----
