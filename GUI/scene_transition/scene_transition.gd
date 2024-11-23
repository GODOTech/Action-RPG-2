extends CanvasLayer

# Get reference to the AnimationPlayer node
@onready var animation_player : AnimationPlayer = $Control/AnimationPlayer

# Function to fade out the CanvasLayer
func fade_out() -> bool:
	# Play the "fade_out" animation
	animation_player.play("fade_out")
	# Wait for the animation to finish
	await  animation_player.animation_finished
	# Return true to indicate successful fade-out
	return true

# Function to fade in the CanvasLayer
func fade_in() -> bool:
	# Play the "fade_in" animation
	animation_player.play("fade_in")
	# Wait for the animation to finish
	await  animation_player.animation_finished
	# Return true to indicate successful fade-in
	return true
