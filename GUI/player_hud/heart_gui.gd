class_name Heart_GUI extends Control


@onready var sprite = $Sprite2D

var value : int = 2 :
	set( _value ): #  Every time that this var get updated do this:
		value = _value
		update_sprite()

func update_sprite() -> void:
	sprite.frame = value
	
