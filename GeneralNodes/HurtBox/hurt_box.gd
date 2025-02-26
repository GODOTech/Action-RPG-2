class_name HurtBox extends Area2D


@export var damage : int = 1  # Amount of damage inflicted by this HurtBox
@export var effect : String  # Placeholder for future effect properties


func _ready():
	area_entered.connect( AreaEntered )

# Function called when an area enters this HurtBox
func AreaEntered( a : Area2D ) -> void:
	# Check if the entered area is a HitBox
	if a is HitBox:
		# Call the TakeDamage function on the HitBox with this HurtBox as the argument
		a.TakeDamage( self )
