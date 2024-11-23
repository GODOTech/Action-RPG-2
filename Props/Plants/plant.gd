class_name Plant extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the Damaged signal from the HitBox node to the TakeDamage function
	$HitBox.Damaged.connect( TakeDamage )
	pass # Replace with function body.

# Function to handle damage to the plant
func TakeDamage( _damage : HurtBox ) -> void:
	# Queue this node for deletion from the scene tree
	queue_free()
	pass # Placeholder, no further actions needed in this function
