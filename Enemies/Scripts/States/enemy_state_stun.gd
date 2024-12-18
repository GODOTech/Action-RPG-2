class_name EnemyStateStun extends EnemyState

@export var anim_name : String = 'stun'

var decelerate_speed : int



@export_category('AI')
@export var next_state : EnemyState

var _damage_position : Vector2
var _direction : Vector2
var _animation_finished : bool = false

func init() -> void:
	enemy.enemy_damaged.connect( _on_enemy_damaged )
	pass

func Enter() -> void:
	#Behavior randomization 
	var knockback_speed : int = randi_range( 10, 500 )
	decelerate_speed = randi_range( 5, 20 )
	
	enemy.invulnerable = true
	_animation_finished = false
	
	#you can also get the player from the player manager global
	_direction = enemy.global_position.direction_to( _damage_position )
	
	enemy.SetDirection( _direction )
	enemy.velocity = _direction * -knockback_speed
	enemy.UpdateAnimation( anim_name )
	enemy.animation_player.animation_finished.connect( _on_animation_finished )
	pass

func Exit() -> void:
	enemy.invulnerable = false
	enemy.animation_player.animation_finished.disconnect( _on_animation_finished )
	pass

func process( _delta : float ) -> EnemyState:
	if _animation_finished == true:
		return next_state
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null

func Physics( _delta : float ) -> EnemyState:
	return null

## normaly on the process func, this time we're forcing it trough a signal:
## no matter on what state you are, you got hit!
func _on_enemy_damaged( hurt_box : HurtBox ) -> void:
	_damage_position = hurt_box.global_position
	state_machine.ChangeState( self )

func _on_animation_finished( _a : String ) -> void:
	_animation_finished = true









