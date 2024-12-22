extends Control


@export var sensitivity_scale = .001 # Scale factor (0.0 to 1.0)

var previous_mouse_position = Vector2.ZERO


func _process( delta ) -> void:
	var threshold: Vector2 = Vector2(1,1)
	var mouse_pos = get_global_mouse_position()
	var screen_size = get_viewport().get_size()
	
	previous_mouse_position = mouse_pos
	
	var mouse_delta = mouse_pos - previous_mouse_position
	mouse_delta *= sensitivity_scale # Scale the delta
	
	if mouse_pos.x < threshold.x :
		var new_pos = Vector2(screen_size.x , mouse_pos.y * 4 )
		Input.warp_mouse(new_pos)
	
	if mouse_pos.y < threshold.y:
		var new_pos = Vector2(mouse_pos.x*4 , screen_size.y )
		Input.warp_mouse(new_pos)
		
	if  mouse_pos.x > 480 :
		var new_pos = Vector2(1, mouse_pos.y * 4 )
		Input.warp_mouse(new_pos)
		
	if mouse_pos.y > 270:
		var new_pos = Vector2(mouse_pos.x * 4 , 1 )
		Input.warp_mouse(new_pos)
	
	
