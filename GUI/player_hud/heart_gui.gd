class_name Heart_GUI extends Control

# Declare and initialize the sprite node
@onready var sprite = $Sprite2D

# Heart value variable, with setter for update logic
var value : int = 2 :
	set( _value ): #  Every time that this var get updated do this:
		value = _value # Set the value to the new value
		update_sprite() # Call the update_sprite function to update the sprite

# Function to update the sprite based on the value
func update_sprite() -> void:
	sprite.frame = value # Set the sprite's frame to the current value
