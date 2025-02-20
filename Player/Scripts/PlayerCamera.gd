class_name PlayerCamera extends Camera2D

@onready var viewport_center_x = get_viewport().size.x / 7.5
@onready var viewport_center_y = get_viewport().size.y / 7.5
@onready var player = get_parent()

var mouse_sensitivity_x = .9 # Horizontal
var mouse_sensitivity_y = .75 # Vertical

# Called when the node enters the scene tree for the first time.
func _ready():
	print("2 Camera SET")
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
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
	#print("5 CAMERA PHYSICS_TICK\n")
	var mouse_pos = get_viewport().get_mouse_position()
	var intended_pos : Vector2 = player.position
	var adjustment_pos = Vector2(0,20)
	
	intended_pos -= adjustment_pos
	
	intended_pos.x += (mouse_pos.x - viewport_center_x) * mouse_sensitivity_x
	intended_pos.y += (mouse_pos.y - viewport_center_y) * mouse_sensitivity_y
	
	
	intended_pos.x = clamp(intended_pos.x, limit_left, limit_right)
	intended_pos.y = clamp(intended_pos.y, limit_top, limit_bottom)
	self.global_position = intended_pos

func _process(delta: float) -> void:
	#print("5 _camera process_tick\n")
	pass
