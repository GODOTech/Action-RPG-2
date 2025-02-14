@tool
class_name ItemPickup extends CharacterBody2D

@export var item_data : ItemData : set = _set_item_data # Run this func every time that this var changes

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	_update_texture()
	if Engine.is_editor_hint(): #if the game is running
		return
	area_2d.area_entered.connect( _on_area_entered)
	area_2d.area_exited.connect( _on_area_exit)

func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide( velocity * delta)
	if  collision_info:
		velocity = velocity.bounce( collision_info.get_normal() )
	velocity -= velocity * delta * 4

func _on_area_entered( _a ) -> void:
	PlayerManager.interact_pressed.connect( player_interact )
	#if b is Player:
	pass

func _on_area_exit( _a ) -> void:
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass

func item_picked_up( ) -> void:
	area_2d.area_entered.disconnect( _on_area_entered )
	audio_stream_player_2d.play()
	visible = false
	await audio_stream_player_2d.finished
	queue_free()
	pass
	

func _set_item_data( value : ItemData ) -> void:
	item_data = value
	_update_texture()
	pass

func _update_texture( ) -> void:
	if item_data and sprite_2d:
		sprite_2d.texture = item_data.texture
	pass

func player_interact():
	if item_data:
			if PlayerManager.INVENTORY_DATA.add_item( item_data ) == true:
				item_picked_up()
	pass
