class_name Enemy extends CharacterBody2D

# Signals
signal  direction_changed( new_direction : Vector2 ) # Signal emitted when the enemy's direction changes
signal enemy_damaged( hurt_box : HurtBox ) # Signal emitted when the enemy takes damage
signal enemy_destroyed( hurt_box : HurtBox ) # Signal emitted when the enemy is destroyed

# Constants
const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ] # Array of cardinal directions


var hp : int = randi_range( 2 ,4 ) # Enemy's health points

# Variables
var cardinal_direction : Vector2 = Vector2.DOWN # Current cardinal direction (initially facing down)
var direction : Vector2 = Vector2.ZERO # Current movement direction
var player: Player # Reference to the player
var invulnerable : bool = false # Flag indicating if the enemy is invulnerable


# Node references
@onready var animation_player : AnimationPlayer = $AnimationPlayer # AnimationPlayer for animations
@onready var sprite : Sprite2D = $Sprite2D # Sprite2D node for visual representation
@onready var hit_box : HitBox = $HitBox # HitBox node for damage detection
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine # EnemyStateMachine node for managing enemy states
@onready var ray_cast: RayCast2D = $RayCast


# Initialization
func _ready():
	# Initialize the EnemyStateMachine
	state_machine.initialize( self )
	# Get a reference to the player from PlayerManager
	player = PlayerManager.player
	# Connect the Damaged signal from HitBox to the _take_damage function
	hit_box.Damaged.connect(_take_damage)
	randomize_look()
	pass

# Process function (called every frame)
func _process(_delta):
	aim()
	pass # Placeholder, no further actions needed in this function

# Physics process function (called at fixed time step)
func _physics_process(_delta):
	move_and_slide()
	#if hp >= 0:
	
	

# Function to set the enemy's direction
func SetDirection(_new_direction : Vector2 ) -> bool:
	# Update the direction vector
	direction = _new_direction
	
	# Return early if there is no direction
	if direction == Vector2.ZERO: return false
	
	# Calculate the direction ID based on input and current direction
	var direction_id : int = int( round(
		( direction + cardinal_direction * 0.1 ).angle()
			/ TAU * DIR_4.size()
		))
	
	# Get the new direction from the DIR_4 array
	var new_dir = DIR_4[ direction_id ]
	
	# Return early if the new direction is the same as the current one
	if new_dir == cardinal_direction:
		return false
	
	# Update the cardinal direction and emit the direction_changed signal
	cardinal_direction = new_dir
	direction_changed.emit( new_dir )
	
	# Flip the sprite based on the new direction
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	# Return true to indicate that the direction has changed
	return true

# Function to update the enemy's animation
func UpdateAnimation( state : String ) -> void:
	# Play the animation based on the state and direction
	animation_player.play(state + "_" + AnimDirection() )
	pass # Placeholder, no further actions needed in this function

# Function to determine the animation direction
func AnimDirection() -> String:
	# Return the appropriate animation direction based on the cardinal direction
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

# Function to handle damage taken by the enemy
func _take_damage( hurt_box : HurtBox ) -> void:
	# Return early if the enemy is invulnerable
	if invulnerable == true: return
	# Reduce HP by the damage amount
	hp -= hurt_box.damage
	# Emit the enemy_damaged signal if HP is greater than 0
	if hp > 0:
		enemy_damaged.emit( hurt_box )
	# Emit the enemy_destroyed signal if HP is 0 or less
	else:
		enemy_destroyed.emit( hurt_box )

func randomize_look() -> void:
	scale= Vector2(randf_range(0.5, 1.5), randf_range( 0.5, 1.5))
	#Scale the whole node tree
	$"/root".get_node(self.get_path()).scale = scale
	
	var rand_mod_r = randi_range(100,200) #RED
	var rand_mod_g = randi_range(180,220) #GREEN
	var rand_mod_b = randi_range(50,100) #BLUE
	var rand_mod_a = randi_range(175,210) #ALPHA
	
	#Set the random values and transparency
	modulate = Color8(rand_mod_r,rand_mod_g,rand_mod_b,rand_mod_a)
	pass

func aim():
	if ray_cast:
		ray_cast.target_position = to_local(player.position)
		var target = ray_cast.get_collider()
		if target == player:
			$EnemyStateMachine/Chase._can_see_player = true
		else:
			$EnemyStateMachine/Chase._can_see_player = false
	else: return


