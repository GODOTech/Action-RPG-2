class_name MusicTrigger extends Area2D

@export var song : AudioStream


func _ready() -> void:
	body_entered.connect(_on_body_enter)
	pass 

func _on_body_enter(body):
	if body.name == "Player":
		GlobalSoundManager.music_player.play()
		pass
	pass
