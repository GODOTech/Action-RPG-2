class_name HurtBox extends Area2D

# Exported properties
@export var damage : int = 1 # Amount of damage inflicted by this HurtBox
#@export var effect :  # Placeholder for future effect properties

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the area_entered signal to the AreaEntered function
	area_entered.connect( AreaEntered )
	pass # Placeholder, no further actions needed in this function

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass # Placeholder, no further actions needed in this function

# Function called when an area enters this HurtBox
func AreaEntered( a : Area2D ) -> void:
	# Check if the entered area is a HitBox
	if a is HitBox:
		# Call the TakeDamage function on the HitBox with this HurtBox as the argument
		a.TakeDamage( self )
	
	pass # Placeholder, no further actions needed in this function
