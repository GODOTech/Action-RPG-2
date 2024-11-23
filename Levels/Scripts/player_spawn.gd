extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Hide the node initially
	visible = false
	# Check if the player has been spawned
	if PlayerManager.player_spawned == false:
		# If the player hasn't been spawned, set its position to this node's position
		PlayerManager.set_player_position( global_position )
		# Set the player_spawned flag to true
		PlayerManager.player_spawned = true
	pass # Placeholder, no further actions needed in this function
