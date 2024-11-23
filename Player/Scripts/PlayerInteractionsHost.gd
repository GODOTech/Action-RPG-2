class_name PlayerInteractionsHost extends Node2D
@onready var player : Player = $".." # Get a reference to the Player node (parent)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the DirectionChanged signal from the Player to the UpdateDirection function
	player.DirectionChanged.connect(UpdateDirection)
	pass # Placeholder, no further actions needed in this function

# Function to update the rotation of this node based on the Player's direction
func UpdateDirection( new_direction : Vector2 )-> void:
	# Use a match statement to set the rotation based on the new direction
	match  new_direction:
		Vector2.DOWN:
			rotation_degrees = 0
		Vector2.UP:
			rotation_degrees = 180
		Vector2.LEFT:
			rotation_degrees = 90
		Vector2.RIGHT:
			rotation_degrees = -90
		_: # Default case if the direction is not recognized
			rotation_degrees = 0
	pass # Placeholder, no further actions needed in this function
