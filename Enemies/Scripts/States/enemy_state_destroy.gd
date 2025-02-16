class_name EnemyStateDestroy extends EnemyState

const PICKUP = preload("res://Items/Item_Pickup/Item_Pickup.tscn")

@export var anim_name : String = 'destroy'
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0
@export var copy_scale : Vector2


@export var gib : PackedScene
@export var corpse : PackedScene
@export var mitosis : PackedScene


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


func _ready():
	
	pass

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
	spawn_gibs()
	spawn_corpse()
	spawn_division()
	pass

func Exit() -> void:
	pass

func process( _delta : float ) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null

func Physics( _delta : float ) -> EnemyState:
	if animation_player.animation_finished:
		enemy.queue_free() # WARNING: to be moved
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
			drop.velocity = enemy.velocity.rotated( randf_range( - 1.5, 1.5 ) ) * randf_range( 0.9, 1.2 )
	pass

func spawn_gibs():
	var gibs_amount: int = randi_range( 5, 10 )
	for i in gibs_amount:
		var gib = gib.instantiate() as Gib
		enemy.get_parent().call_deferred("add_child", gib)
		gib.global_position = enemy.global_position
		gib.velocity = enemy.velocity.rotated(randf_range(-1.5, 1.5)) * randf_range(0.9, 1.2)
	pass

func spawn_corpse() -> void:
	if corpse:
		var corpse = corpse.instantiate()
		enemy.get_parent().call_deferred("add_child", corpse)
		corpse.scale = enemy.scale
		corpse.global_position = enemy.global_position
		corpse.velocity = enemy.velocity.rotated(randf_range(-1.5, 1.5)) * randf_range(0.9, 1.2)

func spawn_division(num_enemies: int = 2) -> void:
	if mitosis:
		for i in range(num_enemies):
			var new_cell = mitosis.instantiate()
			enemy.get_parent().call_deferred("add_child", new_cell)
			new_cell.scale = enemy.scale
			new_cell.global_position = enemy.global_position
			# Add some variation to the position to avoid overlap
			new_cell.global_position += Vector2(randf_range(-10, 10), randf_range(-10, 10))
			new_cell.velocity = enemy.velocity.rotated(randf_range(-1.5, 1.5)) * randf_range(0.9, 1.2)


