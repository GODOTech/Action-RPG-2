extends CanvasLayer
# No class because it would conflict with the autoload name in memory

# Array to store Heart_GUI nodes
var hearts : Array[ Heart_GUI ] = []

# Initialization
func _ready():
	# Get all Heart_GUI nodes from the HFlowContainer
	for child in $Control/HFlowContainer.get_children():
		if child is Heart_GUI:
			# Add the Heart_GUI node to the hearts array
			hearts.append( child )
			# Hide the heart initially
			child.visible = false
	pass # Placeholder, no further actions needed in this function

# Function to update the HP display
func update_hp( _hp: int, _max_hp: int ) -> void:
	# Update the maximum HP display
	update_max_hp( _max_hp )
	# Iterate through the hearts array based on the maximum HP
	for i in _max_hp:
		# Update the individual heart based on its index and current HP
		update_heart( i, _hp )
		pass # Placeholder, no further actions needed in this loop
	pass # Placeholder, no further actions needed in this function

# Function to update a single heart
func update_heart( _index : int, _hp : int ) -> void:
	# Calculate the heart value (0, 1, or 2) based on HP and index
	var _value : int = clampi(_hp - _index * 2, 0, 2)
	# Set the heart's value
	hearts[ _index ].value = _value
	pass # Placeholder, no further actions needed in this function

# Function to update the maximum HP display
func update_max_hp( _max_hp : int ) -> void:
	# Calculate the number of hearts needed
	var _heart_count : int = roundi( _max_hp * 0.5 )
	# Iterate through the hearts array
	for i in hearts.size():
		# Show hearts up to the calculated count
		if i < _heart_count:
			hearts[i].visible = true
		# Hide the rest
		else:
			hearts[i].visible = false
	pass # Placeholder, no further actions needed in this function
