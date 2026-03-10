extends Node2D

@export var width: float = 28.0
@export var height: float = 5.0
@export var bg: Color = Color(0, 0, 0, 0.65)
@export var fg: Color = Color(0.93, 0.29, 0.29, 1)
@export var outline: Color = Color(0.07, 0.09, 0.15, 1)

var _ratio := 1.0

func set_ratio(r: float) -> void:
	_ratio = clampf(r, 0.0, 1.0)
	queue_redraw()

func _draw() -> void:
	var r := Rect2(Vector2(-width * 0.5, -height * 0.5), Vector2(width, height))
	draw_rect(r, bg, true)
	draw_rect(r, outline, false, 1.0)
	var fill := Rect2(r.position + Vector2(1, 1), Vector2((r.size.x - 2) * _ratio, r.size.y - 2))
	draw_rect(fill, fg, true)

