class_name PlayerStateMachine extends Node

# An array to store all the states in the state machine.
var states : Array[ State ] 

# The previous state.
var prev_state : State 

# The current state.
var current_state : State

# Called when the node enters the scene tree for the first time.
func _ready():
	# Disable processing until the state machine is initialized.
	process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Process the current state.
	ChangeState( current_state.Process( delta ) )
	pass

func _physics_process(delta):
	# Process the current state's physics.
	ChangeState( current_state.Physics( delta ) )
	pass

func _unhandled_input(event):
	# Handle input events in the current state.
	ChangeState( current_state.HandleInput( event ))
	pass

# Initializes the state machine with a player object.
func Initialize(_player : Player) -> void:
	# Initialize the states array.
	states = []
	# Add all child nodes that are of type State to the states array.
	for c in get_children():
		if c is State:
			states.append(c)
	
	# If there are any states, initialize the first state.
	if states.size() > 0:
		# Set the player reference for the first state.
		states[0].player = _player 
		# Change to the first state.
		ChangeState( states[0] )
		# Enable processing.
		process_mode = Node.PROCESS_MODE_INHERIT

# Changes the current state of the state machine.
func ChangeState( new_state : State) -> void:
	# If the new state is null or is the same as the current state, return.
	if new_state == null || new_state == current_state:
		return
	
	# If there is a current state, exit it.
	if current_state:
		current_state.Exit()
	
	# Set the previous state.
	prev_state = current_state
	# Set the current state.
	current_state = new_state
	# Enter the new state.
	current_state.Enter() 
