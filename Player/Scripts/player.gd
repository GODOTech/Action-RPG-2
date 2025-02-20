class_name Player extends CharacterBody2D

# Constants
const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP, ] # Array of cardinal directions

# Player properties
var cardinal_direction : Vector2 = Vector2.DOWN  # Current cardinal direction (initially facing down)
var direction : Vector2 = Vector2.ZERO # Current movement direction
var invulnerable : bool = false # Flag indicating if the player is invulnerable
var hp : int = 6 # Player's health points
var max_hp : int = 6 # Player's maximum health points

# Node references
@onready var animation_player : AnimationPlayer = $AnimationPlayer # AnimationPlayer node for main animations
@onready var effect_animation_player : AnimationPlayer = $EffectAnimationPlayer # AnimationPlayer node for effect animations
@onready var sprite : Sprite2D = $Sprite2D # Sprite2D node for visual representation
@onready var state_machine : PlayerStateMachine = $StateMachine # PlayerStateMachine node for managing player states
@onready var hit_box : HitBox = $HitBox # HitBox node for damage detection
@onready var light: Node2D = $Interactions/Area2D/CollisionShape2D/Light

# Signals
signal player_damaged( hurt_box: HurtBox ) # Signal emitted when the player is damaged
signal DirectionChanged( new_direction: Vector2 ) # Signal emitted when the player's direction changes

# Initialization
func _ready():
	print("3 Player SET")
	# Set the player instance in PlayerManager
	PlayerManager.player = self
	# Initialize the PlayerStateMachine
	state_machine.Initialize(self)
	# Connect the Damaged signal from HitBox to the _take_damage function
	hit_box.Damaged.connect( _take_damage )
	# Initialize HP to full
	update_hp(99)
	pass

# Process function (called every frame)
func _process( _delta ):
	#print("4 _player process_tick")
	# Get player input for movement
	direction = Vector2(
		Input.get_axis( "left", "right" ),
		Input.get_axis( "up", "down" )
	).normalized()
	
	# Calculate direction based on player input (alternative method)
	#direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")  # Horizontal movement
	#direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")      # Vertical movement
	#direction = direction.normalized()
	# Set the velocity based on direction and move speed
	
	if Input.is_action_just_pressed("Light"):
		if light.visible: light.visible = false
		else: light.visible = true
	pass

# Physics process function (called at fixed time step)
func _physics_process( _delta ):
	#print("4 PLAYER PHYSICS_TICK")
	# Move the character while sliding on surfaces
	move_and_slide()

# Function to determine the new direction of the player
func SetDirection() -> bool:
	
	# If no input is detected, return false
	if direction == Vector2.ZERO:
		return false
	
# Calculate the direction ID based on player input and current direction
# Calculate the new direction by adding the cardinal direction multiplied by 0.1 to the current direction.
# Find the angle of the new direction.
# Divide the angle by TAU (which is equivalent to 2 * pi) to normalize it between 0 and 1.
# Multiply the normalized angle by the size of the DIR_4 array to determine the index.
# Round the result to the nearest integer to get the final direction_id value.
	var direction_id : int = int( round(
		( direction + cardinal_direction * 0.1 ).angle()
			/ TAU * DIR_4.size()
		))
	
	# Get the new direction from the DIR_4 array
	var new_dir = DIR_4[ direction_id ]
	
	# If the new direction is the same as the current one, return false
	if new_dir == cardinal_direction:
		return false
	
	# Update the cardinal direction and emit the DirectionChanged signal
	cardinal_direction = new_dir
	DirectionChanged.emit( new_dir )
	# Flip the sprite based on the new direction
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	# Return true to indicate that the direction has changed
	return true

# Function to update the player's animation based on the current state and direction
func UpdateAnimation( state : String ) -> void:
	# Play the animation based on state and direction
	animation_player.play( state + "_" + AnimDirection() )
	pass  # Placeholder, no further actions needed in this function

# Function to determine the animation direction based on cardinal direction
func AnimDirection() -> String:
	# Return the appropriate animation direction based on the cardinal direction
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

# Function to handle damage taken by the player
func _take_damage( hurt_box : HurtBox) -> void:
	# Return early if the player is invulnerable
	if invulnerable == true : return
	# Update the player's HP
	update_hp( - hurt_box.damage )
	# Emit the player_damaged signal
	if hp > 0:
		player_damaged.emit( hurt_box )
	else:
		player_damaged.emit( hurt_box )
		update_hp( 99 )
	pass

# Function to update the player's HP
func update_hp( delta : int ) -> void:
	# Clamp HP between 0 and max_hp
	hp = clampi( hp + delta, 0, max_hp )
	# Update the HP display in the HUD
	PlayerHud.update_hp( hp, max_hp)
	pass

# Function to make the player invulnerable for a specified duration
func make_invulnerable( _duration : float = 1.0 ) -> void:
	# Set the invulnerable flag to true
	invulnerable = true
	# Disable damage detection
	hit_box.monitoring = false
	
	# Wait for the specified duration
	await get_tree().create_timer( _duration ).timeout
	
	# Reset invulnerability flag and re-enable damage detection
	invulnerable = false
	hit_box.monitoring = true
	pass # Placeholder, no further actions needed in this function

