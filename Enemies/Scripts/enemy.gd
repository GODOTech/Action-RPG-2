class_name Enemy extends CharacterBody2D

signal  direction_changed( new_direction : Vector2 )
signal enemy_damaged()

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

@export var hp : int = 3

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player: Player
var invulnerable : bool = false


@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
#@onready var hit_box : HitBox = $HitBox
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine

# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine.initialize( self )
	player = PlayerManager.player
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	move_and_slide()

func SetDirection(_new_direction : Vector2 ) -> bool:
	direction = _new_direction
	
	if direction == Vector2.ZERO: return false  
	
	var direction_id : int = int( round( 
			( direction + cardinal_direction * 0.1 ).angle()
			 / TAU * DIR_4.size()
	 ))
	var new_dir = DIR_4[ direction_id ]
	# If the new direction is the same as the current one, do nothing
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	direction_changed.emit( new_dir )  # Update the cardinal direction
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1  # Flip the sprite based on direction
	return true  # Direction changed
	
func UpdateAnimation( state : String ) -> void:
	animation_player.play(state + "_" + AnimDirection() ) 
	pass 

func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"  # Return "down" for downward movement
	elif cardinal_direction == Vector2.UP:
		return "up"  # Return "up" for upward movement
	else:
		return "side"  # Return "side" for left/right movement
