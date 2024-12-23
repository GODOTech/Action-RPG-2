class_name EnemyStateDestroy extends EnemyState

@export var anim_name : String = 'destroy'
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0

@export_category('AI')

@onready var hurt_box: HurtBox = $"../../HurtBox"

var _damage_position : Vector2
var _direction : Vector2


func init() -> void:
	enemy.enemy_destroyed.connect( _on_enemy_destroyed )
	pass

func Enter() -> void:
	hurt_box.monitoring = false
	enemy.invulnerable = true
	
	#you can also get the player from the player manager global
	_direction = enemy.global_position.direction_to( _damage_position )
	
	enemy.SetDirection( _direction )
	enemy.velocity = _direction * -knockback_speed
	enemy.UpdateAnimation( anim_name )
	enemy.animation_player.animation_finished.connect( _on_animation_finished )
	pass

func Exit() -> void:
	pass

func process( _delta : float ) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null

func Physics( _delta : float ) -> EnemyState:
	return null

## normaly on the process func, this time we're forcing it trough a signal:
## no matter on what state you are, you got hit!
func _on_enemy_destroyed(hurt_box2 : HurtBox) -> void: # WARNING the 2 is to prevent a warning
	_damage_position = hurt_box2.global_position
	state_machine.ChangeState( self )

func _on_animation_finished( _a : String ) -> void:
	enemy.queue_free()









