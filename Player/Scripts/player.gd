class_name Player extends CharacterBody2D

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP, ]
# The current cardinal direction the player is facing (initially facing down)
var cardinal_direction : Vector2 = Vector2.DOWN  
# The current movement direction of the player
var direction : Vector2 = Vector2.ZERO             

var invulnerable : bool = false
var hp : int = 6
var max_hp : int = 6

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player : AnimationPlayer = $EffectAnimationPlayer

@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine
@onready var hit_box : HitBox = $HitBox

signal player_damaged( hurt_box: HurtBox )
signal DirectionChanged( new_direction: Vector2 )

func _ready():
	PlayerManager.player = self
	state_machine.Initialize(self)
	hit_box.Damaged.connect( _take_damage )
	update_hp(99)
	pass  

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
	# Play the animation based on state and direction
	animation_player.play(state + "_" + AnimDirection() )  
	pass  

# Function to determine the animation direction based on cardinal direction
func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"  # Return "down" for downward movement
	elif cardinal_direction == Vector2.UP:
		return "up"  # Return "up" for upward movement
	else:
		return "side"  # Return "side" for left/right movement

func _take_damage( hurt_box : HurtBox) -> void:
	if invulnerable == true : return
	update_hp( - hurt_box.damage )
	if hp > 0:
		player_damaged.emit( hurt_box )
	else:
		player_damaged.emit( hurt_box )
		update_hp( 99 )
	pass

func update_hp( delta : int ) -> void:
	hp = clampi( hp + delta, 0, max_hp )
	PlayerHud.update_hp( hp, max_hp) # Connects to the hud
	pass

func make_invulnerable( _duration : float = 1.0 ) -> void:
	invulnerable = true
	hit_box.monitoring = false
	
	await get_tree().create_timer( _duration ).timeout
	
	invulnerable = false
	hit_box.monitoring = true
	pass









