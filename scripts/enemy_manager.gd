extends Node

const ENEMY_SCENE: PackedScene = preload("res://scenes/enemies/Enemy.tscn")

var _player: Node2D
var _time := 0.0
var _spawn_timer := 0.0

var base_spawn_interval := 1.0
var min_spawn_interval := 0.28

func _ready() -> void:
	randomize()

func setup(player: Node2D) -> void:
	_player = player

func _process(delta: float) -> void:
	if not is_instance_valid(_player):
		return
	_time += delta
	_spawn_timer -= delta
	if _spawn_timer <= 0.0:
		_spawn_timer = _current_spawn_interval()
		_spawn_wave()

func _current_spawn_interval() -> float:
	# ramps down over time
	var t := clampf(_time / 120.0, 0.0, 1.0)
	return lerpf(base_spawn_interval, min_spawn_interval, t)

func _spawn_wave() -> void:
	var count := 1 + int(_time / 25.0)
	count = clampi(count, 1, 6)
	for i in range(count):
		_spawn_one()

func _spawn_one() -> void:
	var e: CharacterBody2D = ENEMY_SCENE.instantiate()
	var t := _roll_type()
	var pos := _random_spawn_position(_player.global_position, 520.0, 760.0)
	e.global_position = pos
	add_child(e)
	e.call("setup", _player, t)

func _random_spawn_position(center: Vector2, min_r: float, max_r: float) -> Vector2:
	var angle := randf() * TAU
	var r := lerpf(min_r, max_r, randf())
	return center + Vector2(cos(angle), sin(angle)) * r

func _roll_type() -> int:
	# Gradually introduce tougher enemies.
	var p := clampf(_time / 60.0, 0.0, 1.0)
	var roll := randf()
	if roll < lerpf(0.55, 0.35, p):
		return 0 # tin soldier
	if roll < lerpf(0.80, 0.65, p):
		return 1 # mouse
	if roll < lerpf(0.93, 0.85, p):
		return 2 # rag doll
	if roll < lerpf(0.985, 0.94, p):
		return 3 # duck
	return 4 # jackbox

