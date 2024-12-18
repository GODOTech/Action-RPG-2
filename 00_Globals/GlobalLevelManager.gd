extends Node

# Signals
signal level_load_started # Signal emitted when a level load process starts
signal level_loaded # Signal emitted when a level load process is complete
signal TilemapBoundsChanged( bounds : Array[ Vector2 ] ) # Signal emitted when tilemap bounds change

# Variables
var current_tilemap_bounds : Array[ Vector2 ] # Stores the current tilemap bounds
var target_transition : String # Stores the target transition name for level loading
var position_offset : Vector2 # Stores the position offset for level loading

# Initialization
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	# Wait for the next frame to ensure all nodes are initialized
	await get_tree().process_frame
	# Emit the level_loaded signal to indicate the level is ready
	level_loaded.emit()
	pass # Placeholder, no further actions needed in this function

# Function to change tilemap bounds
func ChangeTilemapBounds( bounds : Array[ Vector2 ] ) -> void:
	# Update the current tilemap bounds
	current_tilemap_bounds = bounds
	# Emit the TilemapBoundsChanged signal with the new bounds
	TilemapBoundsChanged.emit( bounds )

# Function to load a new level
func load_new_level(
		level_path : String, # Path to the new level scene file
		_target_transition : String, # Transition name for the level load
		_position_offset : Vector2 # Position offset for the level load
) -> void:
	
	# Pause the game engine
	get_tree().paused = true
	# Store the target transition and position offset
	target_transition = _target_transition
	position_offset = _position_offset
	# Perform a fade-out transition (assumed to be handled by SceneTransition)
	await  SceneTransition.fade_out()
	
	# Emit the level_load_started signal
	level_load_started.emit()
	# Wait for the next frame to ensure the signal is processed
	await  get_tree().process_frame
	
	# Load the new level scene
	get_tree().change_scene_to_file( level_path )
	# Perform a fade-in transition (assumed to be handled by SceneTransition)
	await  SceneTransition.fade_in()
	
	# Resume the game engine
	get_tree().paused = false
	# Wait for the next frame to ensure the engine is running
	await  get_tree().process_frame
	
	# Emit the level_loaded signal to indicate the level is ready
	level_loaded.emit()
	
	pass # Placeholder, no further actions needed in this function
