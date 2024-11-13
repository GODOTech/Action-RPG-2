class_name HurtBox extends Area2D


@export var damage : int = 1
#@export var effect : 

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect( AreaEntered )
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func AreaEntered( a : Area2D ) -> void:
	if a is HitBox:
		a.TakeDamage( self )
	
	pass
