extends Marker2D

#----

#Vars.
@onready var spr: AnimatedSprite2D = $"../SpritePivot/Sprite";
@export var target: Node2D;
@export var offset: Vector2 = Vector2.ZERO;
#var view_width: 
#var view_height:

#Create
func _ready() -> void: pass;

#Step
func _physics_process(delta: float) -> void: pass;
	
	#Trying to place a marker in front of the player so they can see
	#what they're approaching instead of the camera being dragged behind.
	#position = target.position + offset;

#----
