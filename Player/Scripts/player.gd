class_name Player extends CharacterBody2D

# Initialize variables
var cardinal_direction : Vector2 = Vector2.DOWN  # The current cardinal direction the player is facing (initially facing down)
const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP, ]
var direction : Vector2 = Vector2.ZERO             # The current movement direction of the player
				   # The speed at which the player moves
					 # The current state of the player (idle or walking)

# Onready variables to reference nodes in the scene
@onready var animation_player : AnimationPlayer = $AnimationPlayer  # Reference to the AnimationPlayer node
@onready var sprite : Sprite2D = $Sprite2D                         # Reference to the Sprite2D node
@onready var state_machine : PlayerStateMachine = $StateMachine

signal DirectionChanged( new_direction: Vector2 )

# Called when the node is added to the scene
func _ready():
	PlayerManager.player = self
	state_machine.Initialize(self)
	pass  # Placeholder for future initialization code

# Called every frame
func _process(_delta):
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	
	# Calculate direction based on player input
	#direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")  # Horizontal movement
	#direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")      # Vertical movement
	#direction = direction.normalized()
	# Set the velocity based on direction and move speed
	
	pass 

# Called at a fixed time step (for physics calculations)
func _physics_process(delta):
	move_and_slide()  # Move the character while sliding on surfaces

# Function to determine the new direction of the player
func SetDirection() -> bool:
	
	if direction == Vector2.ZERO:  # If no input is detected
		return false  # No direction change
	
	var direction_id : int = int( round( 
			( direction + cardinal_direction * 0.1 ).angle()
			 / TAU * DIR_4.size()
	 ))
	var new_dir = DIR_4[ direction_id ]
	# If the new direction is the same as the current one, do nothing
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	DirectionChanged.emit( new_dir )  # Update the cardinal direction
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1  # Flip the sprite based on direction
	return true  # Direction changed



# Function to update the player's animation based on the current state and direction
func UpdateAnimation( state : String ) -> void:
	animation_player.play(state + "_" + AnimDirection() )  # Play the animation based on state and direction
	pass  # Placeholder for additional animation logic

# Function to determine the animation direction based on cardinal direction
func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"  # Return "down" for downward movement
	elif cardinal_direction == Vector2.UP:
		return "up"  # Return "up" for upward movement
	else:
		return "side"  # Return "side" for left/right movement
