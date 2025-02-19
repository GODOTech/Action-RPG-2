@tool
class_name LevelTransition extends Area2D

# Define the SIDE enum for transition directions
enum SIDE {LEFT, RIGHT, TOP, BOTTOM}

# Export properties
@export_file("*.tscn") var level # Path to the level scene to load
@export var target_transition_area : String = "LevelTransition" # Name of the target transition area in the next level
@export_category( "Collision Area Settings" )
@export_range( 1, 12, 1, "or_greater" ) var size : int = 2: # Size of the collision area (in tiles)
	set( _v ):
		size = _v
		_update_area() # Update the collision area shape
@export var side : SIDE = SIDE.LEFT : # Side of the transition area
	set( _v ):
		side = _v
		_update_area() # Update the collision area shape
		_snap_to_grid() # Snap the transition area to the grid if enabled
@export var snap_to_grid : bool = false : # Whether to snap the transition area to the grid
	set ( _var ):
		_snap_to_grid() # Snap the transition area to the grid if enabled

# Initialize collision shape
@onready var collision_shape : CollisionShape2D = $CollisionShape2D

# Initialization
func _ready() -> void:
	# Update the collision area shape initially
	_update_area()
	# Return early if in the editor
	if Engine.is_editor_hint(): return
	
	# Disable monitoring initially
	monitoring = false
	# Place the player at the correct position if this is the target transition area
	_place_player()
	
	# Wait for the level to be loaded
	await LevelManager.level_loaded
	
	# Enable monitoring and connect the body_entered signal
	monitoring = true
	body_entered.connect( _player_entered )
	
	pass # Placeholder, no further actions needed in this function

# Function called when a body enters the transition area
func _player_entered( _p : Node2D ) -> void:
	print("\n*************_BEGINING_MAP_TRANSITION_*************\n")
	# Load the new level using the LevelManager
	LevelManager.load_new_level(level, target_transition_area, get_offset())
	pass # Placeholder, no further actions needed in this function

# Function to place the player at the correct position for the transition
func _place_player() -> void:
	# Return early if this is not the target transition area
	if name != LevelManager.target_transition: return
	# Set the player's position using the LevelManager's position offset
	PlayerManager.set_player_position( global_position + LevelManager.position_offset )
	print("\n*************_PLACE_PLAYER_*************\n")

# Function to get the offset for the player position in the next level
func get_offset() -> Vector2:
	# Initialize offset to zero
	var offset : Vector2 = Vector2.ZERO
	# Get the player's global position
	var player_pos = PlayerManager.player.global_position
	
	# Calculate offset based on the transition side
	if side == SIDE.LEFT or side == SIDE.RIGHT:
		offset.y = player_pos.y - global_position.y
		offset.x = 16
		if side == SIDE.LEFT:
			offset.x *= -1
	else:
		offset.x = player_pos.x - global_position.x
		offset.y = 16
		if side == SIDE.TOP:
			offset.y *= -1
	
	return offset

# Function to update the collision area shape based on size and side
func _update_area() -> void:
	# Define the new rectangle size and position
	var new_rect : Vector2 = Vector2( 32,32 )
	var new_position : Vector2 = Vector2.ZERO
	
	# Adjust size and position based on the transition side
	if side == SIDE.TOP:
		new_rect.x *= size
		new_position.y -= 16
	elif  side == SIDE.BOTTOM:
		new_rect.x *= size
		new_position.y += 16
	if side == SIDE.LEFT:
		new_rect.y *= size
		new_position.x -= 16
	elif  side == SIDE.RIGHT:
		new_rect.y *= size
		new_position.x += 16
	
	# Get the collision shape node
	if collision_shape == null:
		collision_shape = get_node( "CollisionShape2D" )
	
	# Set the collision shape's size and position
	collision_shape.shape.size = new_rect
	collision_shape.position = new_position

# Function to snap the transition area to the grid
func _snap_to_grid() -> void:
	# Snap the position to the nearest grid point (16 pixels)
	position.x = round( position.x / 16 ) * 16
	position.y = round( position.y / 16 ) * 16
