extends CanvasLayer

signal shown
signal hidden

@onready var button_save : Button = $Control/HBoxContainer/Button_save
@onready var button_load : Button = $Control/HBoxContainer/Button_load
@onready var item_description: Label = $Control/ItemDescription
@onready var button_quit: Button = $Control/HBoxContainer/Button_quit

@onready var control: Control = get_node("/root/PlayerHud/Control")

var is_paused : bool = false


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	hide_pause_menu()
	button_save.pressed.connect( _on_save_pressed)
	button_load.pressed.connect( _on_load_pressed)
	button_quit.pressed.connect( _on_quit_pressed)
	pass

# Unhandled para que qhede claro que ningun otro sistema esta manejando este evento
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if is_paused == false:
			show_pause_menu()
		else:
			hide_pause_menu()
			# Marcarlo como handled para que ningun otro sistema pueda manejarlo
		get_viewport().set_input_as_handled()


func show_pause_menu() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	visible = true
	is_paused = true
	control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shown.emit()

func hide_pause_menu() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	get_tree().paused = false
	visible = false
	is_paused = false
	control.mouse_filter = Control.MOUSE_FILTER_PASS
	hidden.emit()


func _on_save_pressed() -> void:
	if is_paused == false: return
	SaveManager.save_game()
	hide_pause_menu()
	pass

func _on_load_pressed() -> void:
	if is_paused == false: return
	SaveManager.load_game()
	await LevelManager.level_load_started
	hide_pause_menu()
	pass


func _on_quit_pressed():
	get_tree().quit()

func update_item_description( new_text : String ) -> void:
	item_description.text = new_text


