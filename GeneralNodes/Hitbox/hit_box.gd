class_name HitBox extends Area2D

# Signal emitted when the HitBox is damaged
signal  Damaged( hurt_box : HurtBox )

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Placeholder, no further actions needed in this function

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass # Placeholder, no further actions needed in this function

# Function to handle damage taken by the HitBox
func TakeDamage( hurt_box : HurtBox ) -> void:
	# Emit the Damaged signal with the HurtBox that inflicted damage
	Damaged.emit( hurt_box )
