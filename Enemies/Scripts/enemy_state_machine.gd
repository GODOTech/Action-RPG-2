class_name EnemyStateMachine extends Node

# Variables
var states : Array[ EnemyState ] # Array to store all EnemyState nodes
var prev_state : EnemyState # Reference to the previous state
var current_state : EnemyState # Reference to the current state

# Initialization
func _ready():
	# Disable processing until the state machine is initialized
	process_mode = Node.PROCESS_MODE_DISABLED
	pass

# Process function (called every frame)
func _process(delta):
	# Get the next state from the current state's Process function
	ChangeState(current_state.process( delta ) )
	pass # Placeholder, no further actions needed in this function

# Physics process function (called at fixed time step)
func _physics_process(delta):
	# Get the next state from the current state's Physics function
	ChangeState(current_state.Physics( delta ) )

# Function to initialize the state machine
func initialize( _enemy : Enemy ) -> void:
	# Initialize the states array
	states  = []
	# Find all EnemyState nodes as children of this node
	for  c in get_children():
		if c is EnemyState:
			# Add the EnemyState node to the states array
			states.append( c )
	
	# Initialize each EnemyState node
	for s in states:
		# Set the enemy and state machine references for the state
		s.enemy = _enemy
		s.state_machine = self
		# Call the state's init function
		s.init()
	
	# If there are any states, set the first one as the initial state
	if states.size() > 0 :
		# Change to the first state
		ChangeState( states[0] )
		# Enable processing for this node
		process_mode = Node.PROCESS_MODE_INHERIT

# Function to change the current state
func ChangeState( new_state : EnemyState) -> void:
	# Return early if the new state is null or the same as the current state
	if new_state == null || new_state == current_state:
		return
	
	# If there is a current state, call its Exit function
	if current_state:
		current_state.Exit()
	
	# Update the previous and current states
	prev_state = current_state
	current_state = new_state
	# Call the Enter function of the new state
	current_state.Enter()
