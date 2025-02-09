class_name EnemyStateDestroy extends EnemyState

const PICKUP = preload("res://Items/Item_Pickup/Item_Pickup.tscn")

@export var anim_name : String = 'destroy'
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0


@export_category('AI')

@export_category("Item Drops")
@export var drops : Array[ DropData ]

@onready var ray_cast: RayCast2D = $"../../RayCast"
@onready var hurt_box: HurtBox = $"../../HurtBox"
@onready var attack_hurt_box: HurtBox = $"../../Sprite2D/AttackHurtBox"
@onready var effect_player: AnimationPlayer = $"../../DestroyEffectSprite/AnimationPlayer"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

var _damage_position : Vector2
var _direction : Vector2


func init() -> void:
	enemy.enemy_destroyed.connect( _on_enemy_destroyed )
	pass

func Enter() -> void:
	if attack_hurt_box: attack_hurt_box.monitoring = false
	if hurt_box: hurt_box.monitoring = false
	enemy.invulnerable = true
	
	#you can also get the player from the player manager global
	_direction = enemy.global_position.direction_to( _damage_position )
	
	enemy.SetDirection( _direction )
	enemy.velocity = _direction * -knockback_speed
	enemy.UpdateAnimation( anim_name )
	enemy.animation_player.animation_finished.connect( _on_animation_finished )
	drop_items()
	pass

func Exit() -> void:
	pass

func process( _delta : float ) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null

func Physics( _delta : float ) -> EnemyState:
	if animation_player.animation_finished:
		enemy.queue_free()
	return null

## normaly on the process func, this time we're forcing it trough a signal:
## no matter on what state you are, you got hit!
func _on_enemy_destroyed(hurt_box : HurtBox) -> void:
	_damage_position = hurt_box.global_position
	state_machine.ChangeState( self )

func _on_animation_finished( _a : String ) -> void:
	#enemy.queue_free() WARNING: not working
	pass

func drop_items() -> void:
	if drops.size() == 0 :
		return
	
	for i in drops.size():
		if drops[i] == null or drops [ i ].item == null :
			continue
		var drop_count : int = drops[ i ].get_drop_count()
		for j in drop_count:
			var drop = PICKUP.instantiate() as ItemPickup
			drop.item_data = drops [ i ].item
			enemy.get_parent().call_deferred( "add_child", drop )
			drop.global_position = enemy.global_position
			drop.velocity = enemy.velocity.rotated( randf_range( - 1.5, 1.5 ) ) * randf_range( 0.9, 1.5 )
	pass






