class_name Gib extends CharacterBody2D


@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite_2d.frame = randi_range( 0 , 5 )
	
	pass 


func _process(delta: float) -> void:
	
	pass

func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide( velocity * delta)
	if  collision_info:
		velocity = velocity.bounce( collision_info.get_normal() )
	velocity -= velocity * delta * 4
