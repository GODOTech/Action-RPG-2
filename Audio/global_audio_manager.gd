class_name GlobalAudio extends Node

# remember to make it pausable from the menu

@onready var binaural_player: AudioStreamPlayer = $BinauralPlayer
@onready var ambience_player: AudioStreamPlayer = $AmbiencePlayer
@onready var music_player: AudioStreamPlayer = $MusicPlayer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("0 Audio SET")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
