extends CharacterBody2D

enum Anims {
	Squirm_down,
	Squirm_left,
	Squirm_right,
}

var animation: String = ""

func _ready() -> void:
	var random_anim_index = randi_range(0, Anims.size() - 1) # Get random index
	animation = Anims.keys()[random_anim_index] # Get string key from index
	$AnimationPlayer.play(animation) # Play the animation

func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
	velocity -= velocity * delta * 4
