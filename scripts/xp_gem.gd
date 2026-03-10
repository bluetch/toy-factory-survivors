extends Area2D

@export var amount: int = 5

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	add_to_group("pickups")
	sprite.texture = PixelFactory.tex(PixelFactory.SpriteId.GEM)
	sprite.scale = Vector2(3, 3)

func collect(player: Node) -> void:
	if player != null and player.has_method("add_xp"):
		player.add_xp(amount)
	queue_free()

