extends Node

const PX := 16

enum SpriteId {
	PLAYER,
	BULLET,
	GEM,
	ENEMY_TIN_SOLDIER,
	ENEMY_WINDUP_MOUSE,
	ENEMY_RAG_DOLL,
	ENEMY_ROBO_DUCK,
	ENEMY_JACKBOX,
}

var _cache: Dictionary = {}

func tex(id: int, scale: int = 4) -> Texture2D:
	var key := str(id) + ":" + str(scale)
	if _cache.has(key):
		return _cache[key]
	var tex := _try_load_asset(id)
	if tex == null:
		var img := _make_sprite(id)
		tex = ImageTexture.create_from_image(img)
	_cache[key] = tex
	return tex

func _try_load_asset(id: int) -> Texture2D:
	var path := ""
	match id:
		SpriteId.PLAYER:
			path = "res://assets/sprites/player.png"
		SpriteId.BULLET:
			path = "res://assets/sprites/bullet.png"
		SpriteId.GEM:
			path = "res://assets/sprites/gem.png"
		SpriteId.ENEMY_TIN_SOLDIER:
			path = "res://assets/sprites/enemy_tin_soldier.png"
		SpriteId.ENEMY_WINDUP_MOUSE:
			path = "res://assets/sprites/enemy_windup_mouse.png"
		SpriteId.ENEMY_RAG_DOLL:
			path = "res://assets/sprites/enemy_rag_doll.png"
		SpriteId.ENEMY_ROBO_DUCK:
			path = "res://assets/sprites/enemy_robo_duck.png"
		SpriteId.ENEMY_JACKBOX:
			path = "res://assets/sprites/enemy_jackbox.png"
		_:
			path = ""
	if path == "":
		return null
	var res := load(path)
	if res is Texture2D:
		return res
	return null

func _make_sprite(id: int) -> Image:
	var img := Image.create(PX, PX, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	match id:
		SpriteId.PLAYER:
			_draw_bot(img, Color("#34d399"), Color("#111827"))
		SpriteId.BULLET:
			_draw_bullet(img, Color("#fbbf24"))
		SpriteId.GEM:
			_draw_gem(img, Color("#60a5fa"))
		SpriteId.ENEMY_TIN_SOLDIER:
			_draw_bot(img, Color("#ef4444"), Color("#111827"))
		SpriteId.ENEMY_WINDUP_MOUSE:
			_draw_mouse(img, Color("#a78bfa"), Color("#111827"))
		SpriteId.ENEMY_RAG_DOLL:
			_draw_ragdoll(img, Color("#f472b6"), Color("#111827"))
		SpriteId.ENEMY_ROBO_DUCK:
			_draw_duck(img, Color("#f59e0b"), Color("#111827"))
		SpriteId.ENEMY_JACKBOX:
			_draw_box(img, Color("#22c55e"), Color("#111827"))
		_:
			_draw_box(img, Color("#9ca3af"), Color("#111827"))
	return img

func _px(img: Image, x: int, y: int, c: Color) -> void:
	if x < 0 or y < 0 or x >= PX or y >= PX:
		return
	img.set_pixel(x, y, c)

func _rect(img: Image, x0: int, y0: int, w: int, h: int, c: Color) -> void:
	for y in range(y0, y0 + h):
		for x in range(x0, x0 + w):
			_px(img, x, y, c)

func _outline(img: Image, x0: int, y0: int, w: int, h: int, c: Color) -> void:
	for x in range(x0, x0 + w):
		_px(img, x, y0, c)
		_px(img, x, y0 + h - 1, c)
	for y in range(y0, y0 + h):
		_px(img, x0, y, c)
		_px(img, x0 + w - 1, y, c)

func _draw_bot(img: Image, body: Color, ink: Color) -> void:
	_rect(img, 4, 4, 8, 9, body)
	_outline(img, 4, 4, 8, 9, ink)
	_rect(img, 6, 6, 2, 2, Color("#e5e7eb"))
	_rect(img, 10, 6, 1, 2, Color("#e5e7eb"))
	_rect(img, 5, 13, 3, 2, body.darkened(0.25))
	_rect(img, 9, 13, 3, 2, body.darkened(0.25))

func _draw_mouse(img: Image, body: Color, ink: Color) -> void:
	_rect(img, 5, 7, 6, 5, body)
	_outline(img, 5, 7, 6, 5, ink)
	_rect(img, 3, 6, 3, 3, body.lightened(0.08))
	_outline(img, 3, 6, 3, 3, ink)
	_rect(img, 10, 6, 3, 3, body.lightened(0.08))
	_outline(img, 10, 6, 3, 3, ink)
	_rect(img, 11, 11, 3, 1, ink)

func _draw_ragdoll(img: Image, cloth: Color, ink: Color) -> void:
	_rect(img, 6, 4, 4, 4, Color("#f5d0c5"))
	_outline(img, 6, 4, 4, 4, ink)
	_rect(img, 5, 8, 6, 6, cloth)
	_outline(img, 5, 8, 6, 6, ink)
	_rect(img, 4, 9, 1, 4, cloth.darkened(0.15))
	_rect(img, 11, 9, 1, 4, cloth.darkened(0.15))

func _draw_duck(img: Image, body: Color, ink: Color) -> void:
	_rect(img, 4, 7, 8, 6, body)
	_outline(img, 4, 7, 8, 6, ink)
	_rect(img, 9, 5, 4, 4, body.lightened(0.1))
	_outline(img, 9, 5, 4, 4, ink)
	_rect(img, 12, 8, 2, 1, Color("#fb7185"))

func _draw_box(img: Image, body: Color, ink: Color) -> void:
	_rect(img, 4, 5, 8, 8, body)
	_outline(img, 4, 5, 8, 8, ink)
	_rect(img, 6, 7, 4, 4, body.darkened(0.2))
	_outline(img, 6, 7, 4, 4, ink)
	_rect(img, 7, 8, 2, 2, Color("#e5e7eb"))

func _draw_bullet(img: Image, c: Color) -> void:
	_rect(img, 7, 3, 2, 10, c)
	_rect(img, 6, 5, 4, 6, c.lightened(0.12))

func _draw_gem(img: Image, c: Color) -> void:
	_rect(img, 7, 3, 2, 2, c.lightened(0.2))
	_rect(img, 6, 5, 4, 7, c)
	_rect(img, 7, 12, 2, 1, c.darkened(0.25))
	_outline(img, 6, 5, 4, 7, c.darkened(0.35))

