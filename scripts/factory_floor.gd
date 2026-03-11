extends Node2D

@export var tile_size := 32
@export var half_extent_tiles := 40 # draws a square around this node

var _c_bg := Color("#0b1020")
var _c_tile_a := Color("#121b33")
var _c_tile_b := Color("#0f1730")
var _c_grid := Color(0.35, 0.43, 0.62, 0.08)
var _c_stripe_y := Color("#fbbf24")
var _c_stripe_k := Color("#111827")

func _ready() -> void:
	z_index = -100
	queue_redraw()

func _process(_delta: float) -> void:
	# keep floor centered near player/camera so it looks infinite
	if get_parent() != null and get_parent().has_node("Player"):
		var p: Node2D = get_parent().get_node("Player")
		global_position = p.global_position.snapped(Vector2(tile_size, tile_size))

func _draw() -> void:
	var ts := float(tile_size)
	var extent := int(half_extent_tiles)
	var size_px := Vector2(ts * extent * 2.0, ts * extent * 2.0)
	draw_rect(Rect2(-size_px * 0.5, size_px), _c_bg, true)
	
	for y in range(-extent, extent):
		for x in range(-extent, extent):
			var pos := Vector2(x * ts, y * ts)
			var c := _c_tile_a if ((x + y) & 1) == 0 else _c_tile_b
			draw_rect(Rect2(pos - Vector2(ts * 0.5, ts * 0.5), Vector2(ts, ts)), c, true)
			# subtle grid line
			draw_rect(Rect2(pos - Vector2(ts * 0.5, ts * 0.5), Vector2(ts, 1)), _c_grid, true)
			draw_rect(Rect2(pos - Vector2(ts * 0.5, ts * 0.5), Vector2(1, ts)), _c_grid, true)
	
	# # hazard stripes band
	# var band_h := ts * 2.0
	# var band := Rect2(Vector2(-size_px.x * 0.5, -band_h * 0.5), Vector2(size_px.x, band_h))
	# draw_rect(band, Color(0, 0, 0, 0.0), true)
	# var stripe_w := ts * 0.6
	# var i := int(size_px.x / stripe_w) + 4
	# for n in range(-i, i):
	# 	var x0 := n * stripe_w
	# 	var c2 := _c_stripe_y if (n & 1) == 0 else _c_stripe_k
	# 	# diagonal stripe as a skewed quad using 2 triangles
	# 	var a := Vector2(x0, -band_h * 0.5)
	# 	var b := Vector2(x0 + stripe_w, -band_h * 0.5)
	# 	var c := Vector2(x0 + stripe_w * 1.3, band_h * 0.5)
	# 	var d := Vector2(x0 + stripe_w * 0.3, band_h * 0.5)
	# 	draw_colored_polygon(PackedVector2Array([a, b, c, d]), c2)

