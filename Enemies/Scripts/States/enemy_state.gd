class_name EnemyState extends Node


## Stores a reference to the enemy that this state belongs to
var enemy : Enemy
var state_machine : EnemyStateMachine


func init() -> void:
	pass

func Enter() -> void:
	pass

func Exit() -> void:
	pass

func Process( _delta : float ) -> EnemyState:
	return null

func Physics( _delta : float ) -> EnemyState:
	return null












