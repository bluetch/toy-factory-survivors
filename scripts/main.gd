extends Node

const MENU_SCENE: PackedScene = preload("res://scenes/Menu.tscn")
const GAME_SCENE: PackedScene = preload("res://scenes/Game.tscn")

var _current: Node

func _ready() -> void:
	_show_menu()

func _show_menu() -> void:
	_switch_to(MENU_SCENE.instantiate())
	_current.start_pressed.connect(_on_start_pressed)
	_current.quit_pressed.connect(_on_quit_pressed)

func _show_game() -> void:
	_switch_to(GAME_SCENE.instantiate())
	_current.back_to_menu.connect(_on_back_to_menu)

func _switch_to(next_node: Node) -> void:
	get_tree().paused = false
	if is_instance_valid(_current):
		_current.queue_free()
	_current = next_node
	add_child(_current)

func _on_start_pressed() -> void:
	_show_game()

func _on_back_to_menu() -> void:
	_show_menu()

func _on_quit_pressed() -> void:
	get_tree().quit()

