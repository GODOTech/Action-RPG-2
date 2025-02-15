class_name State_Attack extends State

# Variables
var attacking : bool = false # Flag indicating if the player is attacking

# Node references
@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer" # AnimationPlayer for main animations
@onready var attack_anim : AnimationPlayer = $"../../Sprite2D/AttackEffect/AnimationPlayer" # AnimationPlayer for attack effect
@export_range(1,20,0.5) var decelerate_speed : float = 5.0 # Speed at which the player decelerates during attack
@onready var walk : State = $"../Walk" # Reference to the Walk state
@onready var idle : State = $"../Idle" # Reference to the Idle state
@onready var audio : AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D" # AudioStreamPlayer2D for playing attack sounds
@export var attack_sound : AudioStream # Attack sound to play
@onready var hurt_box : HurtBox = %AttackHurtbox # Reference to the HurtBox node for attack damage

# Initialization
func _ready():
	pass # Placeholder, no further actions needed in this function

# Function called when the player enters the attack state
func Enter() -> void:
	# Update the player's animation to "attack"
	player.UpdateAnimation("attack")
	# Play the attack animation based on the player's direction
	attack_anim.play("attack_" + player.AnimDirection() )
	# Connect the animation_finished signal to the EndAttack function
	animation_player.animation_finished.connect(EndAttack)
	# Set the sound to play and play it with random pitch
	audio.stream = attack_sound
	audio.pitch_scale = randf_range( 3,.5)
	audio.play()
	
	# Set the attacking flag to true
	attacking = true
	
	# Wait for a short delay (0.075 seconds) before enabling damage detection
	await  get_tree().create_timer(0.075).timeout
	hurt_box.monitoring = true
	pass # Placeholder, no further actions needed in this function

# Function called when the player exits the attack state
func Exit() -> void:
	# Disconnect the animation_finished signal
	animation_player.animation_finished.disconnect( EndAttack )
	# Set the attacking flag to false
	attacking = false
	# Disable damage detection
	hurt_box.monitoring = false
	pass # Placeholder, no further actions needed in this function

# Function called every frame while in the attack state
func Process(_delta : float) -> State:
	# Decelerate the player's velocity
	player.velocity -= player.velocity * decelerate_speed * _delta
	# If the player is not attacking, transition to the Idle state
	if attacking == false:
		#if player.direction == Vector2.ZERO: ###
		return idle
	# Otherwise, stay in the Walk state
	else: walk
	# Return null to indicate no state transition
	return null

# Function called at fixed time step while in the attack state
func Physics(_delta : float) -> State:
	# Return null to indicate no state transition
	return null

# Function to handle input events while in the attack state
func HandleInput( _event : InputEvent ) -> State:
	# Return null to indicate no state transition
	return null
	
# Function called when the attack animation finishes
func EndAttack( _newAnimName : String ) -> void :
	# Set the attacking flag to false
	attacking = false
