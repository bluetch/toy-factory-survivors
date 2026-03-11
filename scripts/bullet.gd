extends Area2D

var _dir := Vector2.RIGHT
var _speed := 500.0
var _damage := 10.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var life: Timer = $LifeTimer

func _ready() -> void:
	sprite.texture = PixelFactory.tex(PixelFactory.SpriteId.BULLET)
	sprite.scale = Vector2(3, 3)
	body_entered.connect(_on_body_entered)
	life.timeout.connect(queue_free)

func setup(dir: Vector2, damage: float, speed: float) -> void:
	_dir = dir.normalized()
	_damage = damage
	_speed = speed
	rotation = _dir.angle()

func _physics_process(delta: float) -> void:
	global_position += _dir * _speed * delta

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		body.take_damage(_damage)
	queue_free()
