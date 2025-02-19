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
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	print("1 GlobalLevelManager SET")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
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
	print("\n*************_LOAD_LEVEL_*************\n")
	# Pause the game engine
	get_tree().paused = true
	# Store the target transition and position offset
	target_transition = _target_transition
	position_offset = _position_offset
	# Perform a fade-out transition (assumed to be handled by SceneTransition)
	await  SceneTransition.fade_out()
	
	# Emit the level_load_started signal
	level_load_started.emit()
	print("\n*************_LEVEL_LOAD_STARTED_*************\n")
	# Wait for the next frame to ensure the signal is processed
	await  get_tree().process_frame
	
	# Load the new level scene
	get_tree().change_scene_to_file( level_path )
	print("\n*************_CHANGE_SCENE_*************\n")
	# Perform a fade-in transition (assumed to be handled by SceneTransition)
	await  SceneTransition.fade_in()
	
	# Resume the game engine
	get_tree().paused = false
	print("\n*************_PAUSED_TREE_OFF_*************\n")
	# Wait for the next frame to ensure the engine is running
	await  get_tree().process_frame
	
	# Emit the level_loaded signal to indicate the level is ready
	level_loaded.emit()
	print("\n*************_LEVEL_LOADED_*************\n")
	
	pass # Placeholder, no further actions needed in this function

func _physics_process(delta: float) -> void:
	print("\n1 GLOBAL_LEVEL_MANAGER PHYSICS_TICK")
	pass

func _process(delta: float) -> void:
	print("\n1 _global_level_manager process_tick")
	pass



















