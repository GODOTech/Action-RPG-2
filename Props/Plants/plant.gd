class_name Plant extends Node2D

@onready var hit_box: HitBox = $HitBox
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var static_body_2d: StaticBody2D = $StaticBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var top: Sprite2D = $Top
@onready var top_animation_player: AnimationPlayer = $Top/TopAnimationPlayer

var top_destroyed : bool = false

func _ready():
	# Connect the Damaged signal from the HitBox node to the TakeDamage function
	$HitBox.Damaged.connect( TakeDamage )
	randomize_look()
	pass

# Function to handle damage to the plant
func TakeDamage( _damage : HurtBox ) -> void:
	if top_destroyed == false:
			top_destroyed = true
			top_animation_player.play("top_destroy")
			return
	else:
		hit_box.queue_free()
		static_body_2d.queue_free()
		animation_player.play("destroy")
		top.z_index = -1
		sprite_2d.z_index = -1
	pass

func randomize_look() -> void:
	# whidt, then heigth
	scale = Vector2(randf_range(0.5, 1.5), randf_range( 0.5, 1))
	#Scale the whole node tree
	$"/root".get_node(self.get_path()).scale = scale
	
	var rand_mod_r = randi_range(100,200) #RED
	var rand_mod_g = randi_range(180,200) #GREEN
	var rand_mod_b = randi_range(50,100) #BLUE
	
	# Set the random values and transparency
	# 255 is the MAX
	modulate = Color8(rand_mod_r,rand_mod_g,rand_mod_b,255)
	pass
