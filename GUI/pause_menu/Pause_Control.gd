extends Control

func _ready():
	for inventory_slot in get_tree().get_nodes_in_group("InventorySlot"):
		inventory_slot.item_hovered.connect(update_item_description)

func update_item_description(item_data):
	if item_data != null:
		$ItemDescription.text = item_data.description
	else:
		$ItemDescription.text = ""
