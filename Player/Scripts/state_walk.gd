class_name State_Walk extends State


@export var move_speed : float = 100.0

@onready var idle : State = $"../Idle"
@onready var attack : State = $"../Attack"



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# What happens when the player enters the state
func Enter() -> void:
	player.UpdateAnimation("walk")
	pass

# What happens when the player exits the state
func Exit() -> void:
	pass

func Process(_delta : float) -> State:
	if player.direction == Vector2.ZERO:
		return idle
	
	player.velocity = player.direction * move_speed
	
	if player.SetDirection():
		player.UpdateAnimation("walk")
	return null

# What happens during the _physics_process update in this state?
func Physics(_delta : float) -> State:
	return null

# What happens with inputs in this State?
func HandleInput( _event : InputEvent ) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	if _event.is_action_pressed("interact"):
		PlayerManager.interact_pressed.emit()
		print("moving E")
	return null
	
	
