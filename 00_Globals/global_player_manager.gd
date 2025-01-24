extends Node

# Preload the player scene
const PLAYER = preload("res://Player/player.tscn")
const INVENTORY_DATA : InventoryData = preload("res://GUI/pause_menu/Inventory/player_inventory.tres")
# Player instance and spawn flag
var player : Player # Reference to the player instance
var player_spawned : bool = false # Flag indicating if the player has been spawned

# Initialization
func _ready() -> void:
	# Add a player instance to the scene
	add_player_instance()
	# Wait for a short timer (0.2 seconds)
	await get_tree(). create_timer(0.2).timeout
	# Set the player_spawned flag to true
	player_spawned = true

# Function to add a player instance
func add_player_instance() -> void:
	# Instantiate the player scene
	player = PLAYER.instantiate()
	# Add the player instance as a child of this node
	add_child( player )
	pass # Placeholder, no further actions needed in this function

func set_health( hp: int, max_hp: int ) -> void:
	player.max_hp = max_hp
	player.hp = hp
	player.update_hp( 0 )


# Function to set the player's position
func set_player_position( _new_pos : Vector2 ) -> void:
	# Set the player's global position
	player.global_position = _new_pos
	pass # Placeholder, no further actions needed in this function

# Function to set a new parent for the player
func set_as_parent( _p : Node2D ) -> void:
	# If the player has a parent, remove it
	if player.get_parent():
		player.get_parent().remove_child( player )
	# Add the player as a child of the new parent
	_p.add_child( player )

# Function to remove the player from a parent
func unparent_player( _p : Node2D ) -> void:
	# Remove the player from the specified parent
	_p.remove_child( player )
