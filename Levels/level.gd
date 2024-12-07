class_name Level extends Node2D

func _ready() -> void:
	# Enable y-sorting for this node
	self.y_sort_enabled = true
	# Set this node as the parent of the PlayerManager's player instance
	PlayerManager.set_as_parent( self )
	# Connect the level_load_started signal from LevelManager to the _free_level function
	LevelManager.level_load_started.connect(_free_level )

# Function to handle the level_load_started signal
func _free_level() -> void:
	# Remove the player instance from this node
	PlayerManager.unparent_player( self )
	# Queue this node for deletion from the scene tree
	queue_free()
