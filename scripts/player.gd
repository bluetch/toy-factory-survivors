extends CharacterBody2D

signal died
signal stats_changed(hp: float, max_hp: float)
signal xp_changed(xp: int, xp_to_next: int, level: int)
signal level_up(options: Array)

const BULLET_SCENE: PackedScene = preload("res://scenes/Bullet.tscn")

var speed := 220.0
var max_hp := 100.0
var hp := 100.0
var damage := 18.0
var fire_rate := 1.0 # shots per second
var bullet_speed := 560.0
var pickup_radius := 64.0

var level := 1
var xp := 0
var xp_to_next := 20

var _hurt_cooldown := 0.35
var _hurt_timer := 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var hurt_area: Area2D = $HurtArea
@onready var pickup_area: Area2D = $PickupArea
@onready var shoot_timer: Timer = $ShootTimer
@onready var pickup_shape: CollisionShape2D = $PickupArea/PickupShape

func _ready() -> void:
	sprite.texture = PixelFactory.tex(PixelFactory.SpriteId.PLAYER)
	sprite.scale = Vector2(4, 4)
	_set_pickup_radius(pickup_radius)
	hurt_area.body_entered.connect(_on_hurt_body_entered)
	hurt_area.body_exited.connect(_on_hurt_body_exited)
	pickup_area.area_entered.connect(_on_pickup_area_entered)
	_update_shoot_timer()
	emit_stats()
	emit_xp()
	shoot_timer.timeout.connect(_try_shoot)

func _physics_process(delta: float) -> void:
	var input := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	if input.length() > 1.0:
		input = input.normalized()
	velocity = input * speed
	move_and_slide()
	
	_hurt_timer = maxf(0.0, _hurt_timer - delta)
	if _hurt_timer <= 0.0 and _touching_enemies.size() > 0:
		_try_take_contact_damage()
	if input.x != 0:
		sprite.flip_h = input.x < 0

func emit_stats() -> void:
	stats_changed.emit(hp, max_hp)

func emit_xp() -> void:
	xp_changed.emit(xp, xp_to_next, level)

var _touching_enemies: Array[Node] = []

func _on_hurt_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		_touching_enemies.append(body)
		_try_take_contact_damage()

func _on_hurt_body_exited(body: Node) -> void:
	_touching_enemies.erase(body)

func _try_take_contact_damage() -> void:
	if _hurt_timer > 0.0:
		return
	_hurt_timer = _hurt_cooldown
	var total := 0.0
	for e in _touching_enemies:
		if is_instance_valid(e) and e.has_method("get_contact_damage"):
			total += e.get_contact_damage()
	if total <= 0.0:
		total = 6.0
	_take_damage(total)

func _take_damage(amount: float) -> void:
	hp = maxf(0.0, hp - amount)
	emit_stats()
	if hp <= 0.0:
		died.emit()

func heal(amount: float) -> void:
	hp = minf(max_hp, hp + amount)
	emit_stats()

func _on_pickup_area_entered(area: Area2D) -> void:
	if area.is_in_group("pickups") and area.has_method("collect"):
		area.collect(self)

func add_xp(amount: int) -> void:
	xp += amount
	while xp >= xp_to_next:
		xp -= xp_to_next
		level += 1
		xp_to_next = int(round(xp_to_next * 1.25 + 6))
		emit_xp()
		level_up.emit(_roll_upgrades())
		return
	emit_xp()

func _roll_upgrades() -> Array:
	var pool := [
		{"id": "damage", "name": "加強火力", "desc": "+20% 傷害"},
		{"id": "firerate", "name": "更快射擊", "desc": "+20% 射速"},
		{"id": "maxhp", "name": "更結實", "desc": "+25 最大生命"},
		{"id": "speed", "name": "滑步輪鞋", "desc": "+12% 移動速度"},
		{"id": "pickup", "name": "磁鐵手套", "desc": "+35% 拾取半徑"},
		{"id": "heal", "name": "快速維修", "desc": "立即回復 30 生命"},
	]
	pool.shuffle()
	return pool.slice(0, 3)

func apply_upgrade(upgrade_id: String) -> void:
	match upgrade_id:
		"damage":
			damage *= 1.2
		"firerate":
			fire_rate *= 1.2
			_update_shoot_timer()
		"maxhp":
			max_hp += 25.0
			hp += 25.0
		"speed":
			speed *= 1.12
		"pickup":
			pickup_radius *= 1.35
			_set_pickup_radius(pickup_radius)
		"heal":
			heal(30.0)
	emit_stats()
	emit_xp()

func _set_pickup_radius(r: float) -> void:
	var shape := pickup_shape.shape
	if shape is CircleShape2D:
		shape.radius = r

func _update_shoot_timer() -> void:
	var interval := 1.0 / maxf(0.15, fire_rate)
	shoot_timer.wait_time = interval

func _try_shoot() -> void:
	var target := _nearest_enemy()
	if target == null:
		return
	var dir := (target.global_position - global_position).normalized()
	if dir == Vector2.ZERO:
		dir = Vector2.RIGHT
	var b: Area2D = BULLET_SCENE.instantiate()
	b.global_position = global_position
	b.call("setup", dir, damage, bullet_speed)
	get_parent().add_child(b)

func _nearest_enemy() -> Node2D:
	var nearest: Node2D = null
	var best := INF
	for e in get_tree().get_nodes_in_group("enemies"):
		if not (e is Node2D):
			continue
		if e.has_method("is_dead") and e.is_dead():
			continue
		var d := global_position.distance_squared_to(e.global_position)
		if d < best:
			best = d
			nearest = e
	return nearest

