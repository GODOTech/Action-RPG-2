class_name PlayerCamera extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print("2 Camera SET")
	# Connect the TilemapBoundsChanged signal from LevelManager to the UpdateLimits function
	LevelManager.TilemapBoundsChanged.connect( UpdateLimits )
	# Call UpdateLimits initially with the current tilemap bounds
	UpdateLimits( LevelManager.current_tilemap_bounds )
	pass # Placeholder, no further actions needed in this function

# Function to update the camera's limits based on the tilemap bounds
func UpdateLimits(bounds : Array[ Vector2 ] ) -> void:
	# Return early if the bounds array is empty
	if bounds == [] : return
	# Set the camera limits based on the provided bounds
	limit_left = int( bounds[0].x )
	limit_top = int( bounds[0].y )
	limit_right = int( bounds[1].x )
	limit_bottom = int( bounds[1].y )
	pass # Placeholder, no further actions needed in this function

func _physics_process(delta: float) -> void:
	print("5 CAMERA PHYSICS_TICK\n")
	pass

func _process(delta: float) -> void:
	print("5 _camera process_tick\n")
	pass
