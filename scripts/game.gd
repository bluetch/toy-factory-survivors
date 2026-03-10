extends Node2D

signal back_to_menu

@onready var player: CharacterBody2D = $World/Player
@onready var enemy_manager: Node = $World/EnemyManager
@onready var camera: Camera2D = $World/Camera2D
@onready var hud: CanvasLayer = $HUD

func _ready() -> void:
	camera.position = player.position
	player.died.connect(_on_player_died)
	player.stats_changed.connect(_on_player_stats_changed)
	player.xp_changed.connect(_on_player_xp_changed)
	player.level_up.connect(_on_player_level_up)
	hud.request_resume.connect(_on_request_resume)
	hud.request_back_to_menu.connect(func(): back_to_menu.emit())
	hud.upgrade_chosen.connect(player.apply_upgrade)
	
	enemy_manager.setup(player)

func _process(_delta: float) -> void:
	camera.position = player.position

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_toggle_pause()

func _toggle_pause() -> void:
	var paused := not get_tree().paused
	get_tree().paused = paused
	hud.set_paused(paused)

func _on_request_resume() -> void:
	get_tree().paused = false
	hud.set_paused(false)

func _on_player_died() -> void:
	get_tree().paused = true
	hud.show_game_over()

func _on_player_stats_changed(hp: float, max_hp: float) -> void:
	hud.set_hp(hp, max_hp)

func _on_player_xp_changed(xp: int, xp_to_next: int, level: int) -> void:
	hud.set_xp(xp, xp_to_next, level)

func _on_player_level_up(options: Array) -> void:
	get_tree().paused = true
	hud.show_level_up(options)
