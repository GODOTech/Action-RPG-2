class_name State_Attack extends State

var attacking : bool = false

@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_anim : AnimationPlayer = $"../../Sprite2D/AttackEffect/AnimationPlayer"
@export_range(1,20,0.5) var decelerate_speed : float = 5.0

@onready var walk : State = $"../Walk"
@onready var idle : State = $"../Idle"

@onready var audio : AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@export var attack_sound : AudioStream

@onready var hurt_box : HurtBox = %AttackHurtbox # The only node with that name, can acces it from anYwhere



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# What happens when the player enters the state
func Enter() -> void:
	player.UpdateAnimation("attack")
	attack_anim.play("attack_" + player.AnimDirection() )
	animation_player.animation_finished.connect(EndAttack)
	audio.stream = attack_sound
	audio.pitch_scale = randf_range( 8.9, 1.1)
	audio.play()
	
	attacking = true
	
	await  get_tree().create_timer(0.075).timeout
	hurt_box.monitoring = true
	pass

# What happens when the player exits the state
func Exit() -> void:
	animation_player.animation_finished.disconnect(EndAttack)
	attacking = false
	hurt_box.monitoring = false
	pass

func Process(_delta : float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	if attacking == false:
		#if player.direction == Vector2.ZERO: ###
		return idle
	else :
		walk
	return null

# What happens during the _physics_process update in this state?
func Physics(_delta : float) -> State:
	return null

# What happens with inputs in this State?
func HandleInput( _event : InputEvent ) -> State:
	return null
	
func EndAttack( _newAnimName : String ) -> void :
	attacking = false
	
