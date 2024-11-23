class_name LevelTileMap extends TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the tilemap bounds and emit the ChangeTilemapBounds signal to LevelManager
	LevelManager.ChangeTilemapBounds( GetTilemapBounds() )
	pass # Placeholder, no further actions needed in this function

# Function to get the tilemap bounds
func GetTilemapBounds() -> Array[ Vector2 ]:
	# Initialize an empty array to store the bounds
	var bounds: Array[ Vector2 ] = []
	# Append the bottom-left corner of the used rectangle (in tile coordinates) multiplied by the rendering quadrant size
	bounds.append(
		Vector2(get_used_rect().position * rendering_quadrant_size)
	)
	# Append the top-right corner of the used rectangle (in tile coordinates) multiplied by the rendering quadrant size
	bounds.append(
		Vector2( get_used_rect().end * rendering_quadrant_size )
	)
	# Return the bounds array
	return bounds
