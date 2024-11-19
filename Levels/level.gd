class_name Level extends Node2D


func _ready():
	self.y_sort_enabled = true
	PlayerManager.set_as_parent( self )
	pass 
