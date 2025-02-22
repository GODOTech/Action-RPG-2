class_name Enemy
extends CharacterBody2D


signal direction_changed( new_direction : Vector2 ) # Signal emitted when the enemy's direction changes
signal enemy_damaged( hurt_box : HurtBox ) # Signal emitted when the enemy takes damage
signal enemy_destroyed( hurt_box : HurtBox ) # Signal emitted when the enemy is destroyed

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ] # Array of cardinal directions

var HP : int 
var ATTACK : int

var cardinal_direction : Vector2 = Vector2.DOWN # Current cardinal direction (initially facing down)
var direction : Vector2 = Vector2.ZERO # Current movement direction
var player: Player # Reference to the player
var invulnerable : bool = false # Flag indicating if the enemy is invulnerable
var in_cone: bool = false

@onready var animation_player : AnimationPlayer = $AnimationPlayer # AnimationPlayer for animations
@onready var sprite : Sprite2D = $Sprite2D # Sprite2D node for visual representation
@onready var hit_box : HitBox = $HitBox # HitBox node for damage detection
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine # EnemyStateMachine node for managing enemy states
@onready var ray_cast: RayCast2D = $RayCast
@onready var vision_area: VisionArea = $VisionArea
@onready var hurt_box: HurtBox = $Sprite2D/HurtBox


@export_category("Randomization values")
@export_group("Color")
@export var Red_min = 100
@export var Red_max = 200

@export var green_min = 180
@export var green_max = 220

@export var blue_min = 50
@export var blue_max = 100

@export_subgroup("Transparency")
@export var alpha_min = 175
@export var alpha_max = 210

@export_group("Size")
@export var X_min : float = 0.5
@export var X_max : float  = 1.5
@export var Y_min : float = 0.5
@export var Y_max : float  = 1.5


func _ready():
	state_machine.initialize( self )
	player = PlayerManager.player
	# Connect the Damaged signal from HitBox to the _take_damage function
	hit_box.Damaged.connect(_take_damage)
	randomize_look()
	get_mass()
	set_damage()

func _process(_delta):
	
	pass 

# Physics process function (called at fixed time step)
func _physics_process(_delta):
	move_and_slide()
	if in_cone: aim()

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

func UpdateAnimation( state : String ) -> void:
	# Play the animation based on the state and direction
	animation_player.play(state + "_" + AnimDirection() )
	pass # Placeholder, no further actions needed in this function

func AnimDirection() -> String:
	# Return the appropriate animation direction based on the cardinal direction
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func _take_damage( hurt_box : HurtBox ) -> void:
	if invulnerable == true: return
	HP -= hurt_box.damage
	if HP > 0:
		enemy_damaged.emit( hurt_box )
	else:
		enemy_destroyed.emit( hurt_box )

func randomize_look() -> void:
# Red, Green, Blue, Alpha(transparency); (min=0 , max=255).
	var rand_mod_r = randi_range(Red_min,Red_max)
	var rand_mod_g = randi_range(green_min,green_max)
	var rand_mod_b = randi_range(blue_min,blue_max)
	var rand_mod_a = randi_range(alpha_min,alpha_max)
# Set the values to this particular itteration
	modulate = Color8(rand_mod_r,rand_mod_g,rand_mod_b,rand_mod_a)
# Set the size of the whole node tree with exported values(min=0.5, max=1.5).
	scale = Vector2(randf_range(X_min, X_max), randf_range( Y_min, Y_max))
	$"/root".get_node(self.get_path()).scale = scale

func get_mass() -> void:
# Use the random values to get the new variable.
	var mass = scale.x + scale.y
# Extract the combat efective values with diferent segmentations.
	var attack = round(mass)
	var hp = floor( mass *2)
# DeBugging report:
	print("\n", name)
	print("scale_x: ", snapped( scale.x, 0.01 ) )
	print("scale_y: ", snapped( scale.y, 0.01 ) )
	print("Mass:    ", snapped( mass, 0.01 ), "\n")
	print("ATTACK: ", attack)
	print("HP:     ", hp, "\n" )
# Set the itteration values to the ones originated trough randomization
	HP = hp
	ATTACK = attack

func set_damage():
	if hurt_box:
		hurt_box.damage = ATTACK
	pass

func aim():
	if player.light.visible == true: 
			$EnemyStateMachine/Chase._can_see_player = true
	else :
		if ray_cast:
			ray_cast.target_position = to_local(player.position)
			var target = ray_cast.get_collider()
			if target == player:
				$EnemyStateMachine/Chase._can_see_player = true
			else:
				$EnemyStateMachine/Chase._can_see_player = false
		else: return

func _player_enter():
	in_cone = true

func _player_exit():
	in_cone = false

