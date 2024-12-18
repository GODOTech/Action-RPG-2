class_name Plant extends Node2D

@onready var hit_box: HitBox = $HitBox
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var static_body_2d: StaticBody2D = $StaticBody2D

func _ready():
	# Connect the Damaged signal from the HitBox node to the TakeDamage function
	$HitBox.Damaged.connect( TakeDamage )
	randomize_look()
	pass

# Function to handle damage to the plant
func TakeDamage( _damage : HurtBox ) -> void:
	hit_box.queue_free()
	static_body_2d.queue_free()
	sprite_2d.queue_free()
	
	pass

func randomize_look() -> void:
	# whidt, then heigth
	var scale = Vector2(randf_range(0.5, 1.5), randf_range( 0.5, 1))
	#Scale the whole node tree
	$"/root".get_node(self.get_path()).scale = scale
	
	var rand_mod_r = randi_range(100,200) #RED
	var rand_mod_g = randi_range(180,200) #GREEN
	var rand_mod_b = randi_range(50,100) #BLUE
	var rand_mod_a = randi_range(175,210) #ALPHA
	
	# Set the random values and transparency
	# 255 is the MAX
	modulate = Color8(rand_mod_r,rand_mod_g,rand_mod_b,255)
	pass
