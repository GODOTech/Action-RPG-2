class_name InventoryData  extends Resource

@export var slots : Array[ SlotData ]


func _init() -> void: # Equivalent to the _Ready function, but for resources
	connect_slots()
	pass

func add_item(item: ItemData, count : int = 1) -> bool: # defalut quantity 1
	for s in slots:
		if s:
			if s.item_data == item: # if its the same type of item
				s.quantity += count # normally one
				return true # added an existing item to that slot!
	
	for i in slots.size():
		if slots[ i ] == null: # if the invwentory is empty
			var new = SlotData.new() # create a new slot data
			new.item_data = item # set the new item's  data to the pickup (item)
			new.quantity = count # normally just one
			slots [ i ] = new # add the new item to the slots array
			new.changed.connect(slot_changed)
			return true # added a new item! 
	
	print("inventory was full!")
	return false

func connect_slots() -> void:
	for s in slots:
		if s:
			s.changed.connect( slot_changed )

func slot_changed() -> void:
	for s in slots:
		if s:
			if s.quantity < 1:
				s.changed.disconnect( slot_changed )
				var index = slots.find( s )
				slots[ index ] = null
				emit_changed()
	pass
