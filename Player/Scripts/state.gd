class_name State extends Node

# Stores a reference to the player that thus State belongs to
static var player : Player
static var state_machine : PlayerStateMachine


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

## What happens when we initialize this state
func init() -> void:
	pass

# What happens when the player enters the state
func Enter() -> void:
	pass

# What happens when the player exits the state
func Exit() -> void:
	pass

func Process(_delta : float) -> State:
	return null

# What happens during the _physics_process update in this state?
func Physics(_delta : float) -> State:
	return null

# What happens with inputs in this State?
func HandleInput( _event : InputEvent ) -> State:
	return null
	
	
