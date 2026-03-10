extends CharacterBody2D

const GEM_SCENE: PackedScene = preload("res://scenes/XPGem.tscn")

enum EnemyType {
	TIN_SOLDIER,
	WINDUP_MOUSE,
	RAG_DOLL,
	ROBO_DUCK,
	JACKBOX,
}

@export var enemy_type: int = EnemyType.TIN_SOLDIER

var max_hp := 30.0
var hp := 30.0
var speed := 95.0
var contact_damage := 8.0
var xp_value := 6

var _player: Node2D
var _dead := false

@onready var sprite: Sprite2D = $Sprite2D
@onready var hp_bar: Node2D = $HPBar

func _ready() -> void:
	add_to_group("enemies")
	_apply_type(enemy_type)
	hp = max_hp
	_update_hp_bar()

func setup(player: Node2D, t: int) -> void:
	_player = player
	enemy_type = t
	_apply_type(enemy_type)
	hp = max_hp
	_update_hp_bar()

func _physics_process(_delta: float) -> void:
	if _dead:
		return
	if not is_instance_valid(_player):
		return
	var dir := (_player.global_position - global_position)
	if dir.length() > 0.001:
		dir = dir.normalized()
	velocity = dir * speed
	move_and_slide()
	if dir.x != 0:
		sprite.flip_h = dir.x < 0

func take_damage(amount: float) -> void:
	if _dead:
		return
	hp = maxf(0.0, hp - amount)
	_update_hp_bar()
	if hp <= 0.0:
		_die()

func _die() -> void:
	_dead = true
	_spawn_gem()
	queue_free()

func _spawn_gem() -> void:
	var g: Area2D = GEM_SCENE.instantiate()
	g.global_position = global_position
	g.amount = xp_value
	get_parent().add_child(g)

func _update_hp_bar() -> void:
	if is_instance_valid(hp_bar) and hp_bar.has_method("set_ratio"):
		hp_bar.set_ratio(hp / max_hp)

func get_contact_damage() -> float:
	return contact_damage

func is_dead() -> bool:
	return _dead

func _apply_type(t: int) -> void:
	match t:
		EnemyType.TIN_SOLDIER:
			max_hp = 34.0
			speed = 92.0
			contact_damage = 8.0
			xp_value = 6
			sprite.texture = PixelFactory.tex(PixelFactory.SpriteId.ENEMY_TIN_SOLDIER)
		EnemyType.WINDUP_MOUSE:
			max_hp = 22.0
			speed = 120.0
			contact_damage = 6.0
			xp_value = 5
			sprite.texture = PixelFactory.tex(PixelFactory.SpriteId.ENEMY_WINDUP_MOUSE)
		EnemyType.RAG_DOLL:
			max_hp = 46.0
			speed = 80.0
			contact_damage = 10.0
			xp_value = 8
			sprite.texture = PixelFactory.tex(PixelFactory.SpriteId.ENEMY_RAG_DOLL)
		EnemyType.ROBO_DUCK:
			max_hp = 28.0
			speed = 110.0
			contact_damage = 7.0
			xp_value = 6
			sprite.texture = PixelFactory.tex(PixelFactory.SpriteId.ENEMY_ROBO_DUCK)
		EnemyType.JACKBOX:
			max_hp = 60.0
			speed = 70.0
			contact_damage = 12.0
			xp_value = 11
			sprite.texture = PixelFactory.tex(PixelFactory.SpriteId.ENEMY_JACKBOX)
		_:
			max_hp = 30.0
			speed = 95.0
			contact_damage = 8.0
			xp_value = 6
			sprite.texture = PixelFactory.tex(PixelFactory.SpriteId.ENEMY_TIN_SOLDIER)
	sprite.scale = Vector2(4, 4)

