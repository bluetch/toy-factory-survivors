extends CanvasLayer

signal request_resume
signal request_back_to_menu
signal upgrade_chosen(upgrade_id: String)

@onready var hp_bar: ProgressBar = %HPBar
@onready var xp_bar: ProgressBar = %XPBar
@onready var level_label: Label = %LevelLabel

@onready var pause_panel: Control = %PausePanel
@onready var resume_btn: Button = %ResumeBtn
@onready var back_btn: Button = %BackBtn

@onready var game_over_panel: Control = %GameOverPanel
@onready var game_over_back_btn: Button = %GameOverBackBtn

@onready var level_up_panel: Control = %LevelUpPanel
@onready var choice_btns: Array[Button] = [%Choice1, %Choice2, %Choice3]

var _choice_ids: Array[String] = ["", "", ""]

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_apply_factory_ui()
	resume_btn.pressed.connect(func(): request_resume.emit())
	back_btn.pressed.connect(func(): request_back_to_menu.emit())
	game_over_back_btn.pressed.connect(func(): request_back_to_menu.emit())
	for i in range(choice_btns.size()):
		var idx := i
		choice_btns[i].pressed.connect(func(): _choose(idx))

func _apply_factory_ui() -> void:
	var panel_tex: Texture2D = load("res://assets/ui/metal_panel.png")
	var stripes: Texture2D = load("res://assets/ui/hazard_stripes.png")
	
	var make_panel := func(p: Control, accent: Color) -> void:
		if p is PanelContainer and panel_tex != null:
			var sb := StyleBoxTexture.new()
			sb.texture = panel_tex
			sb.texture_margin_left = 10
			sb.texture_margin_top = 10
			sb.texture_margin_right = 10
			sb.texture_margin_bottom = 10
			p.add_theme_stylebox_override("panel", sb)
		p.add_theme_color_override("font_color", Color("#E5E7EB"))
		p.modulate = Color(1, 1, 1, 1)
	
	make_panel.call(pause_panel, Color("#FBBF24"))
	make_panel.call(game_over_panel, Color("#EF4444"))
	make_panel.call(level_up_panel, Color("#60A5FA"))
	
	var btn := func(b: Button, accent: Color) -> void:
		var normal := StyleBoxFlat.new()
		normal.bg_color = Color("#0b1224")
		normal.border_width_left = 2
		normal.border_width_top = 2
		normal.border_width_right = 2
		normal.border_width_bottom = 2
		normal.border_color = accent
		normal.corner_radius_top_left = 6
		normal.corner_radius_top_right = 6
		normal.corner_radius_bottom_left = 6
		normal.corner_radius_bottom_right = 6
		normal.content_margin_left = 14
		normal.content_margin_right = 14
		normal.content_margin_top = 10
		normal.content_margin_bottom = 10
		
		var hover := normal.duplicate()
		hover.bg_color = Color("#122040")
		var pressed := normal.duplicate()
		pressed.bg_color = Color("#070c18")
		
		b.add_theme_stylebox_override("normal", normal)
		b.add_theme_stylebox_override("hover", hover)
		b.add_theme_stylebox_override("pressed", pressed)
		b.add_theme_color_override("font_color", Color("#E5E7EB"))
		b.add_theme_color_override("font_hover_color", Color("#F9FAFB"))
		b.add_theme_color_override("font_pressed_color", Color("#FDE68A"))
	
	btn.call(resume_btn, Color("#FBBF24"))
	btn.call(back_btn, Color("#60A5FA"))
	btn.call(game_over_back_btn, Color("#FBBF24"))
	for b in choice_btns:
		btn.call(b, Color("#34D399"))
	
	# Progress bars: simple industrial look
	var bg := StyleBoxFlat.new()
	bg.bg_color = Color("#0b1224")
	bg.border_width_left = 2
	bg.border_width_top = 2
	bg.border_width_right = 2
	bg.border_width_bottom = 2
	bg.border_color = Color("#111827")
	bg.corner_radius_top_left = 4
	bg.corner_radius_top_right = 4
	bg.corner_radius_bottom_left = 4
	bg.corner_radius_bottom_right = 4
	
	var hp_fill := StyleBoxFlat.new()
	hp_fill.bg_color = Color("#EF4444")
	hp_fill.corner_radius_top_left = 3
	hp_fill.corner_radius_top_right = 3
	hp_fill.corner_radius_bottom_left = 3
	hp_fill.corner_radius_bottom_right = 3
	
	var xp_fill := StyleBoxFlat.new()
	xp_fill.bg_color = Color("#60A5FA")
	xp_fill.corner_radius_top_left = 3
	xp_fill.corner_radius_top_right = 3
	xp_fill.corner_radius_bottom_left = 3
	xp_fill.corner_radius_bottom_right = 3
	
	hp_bar.add_theme_stylebox_override("background", bg)
	hp_bar.add_theme_stylebox_override("fill", hp_fill)
	xp_bar.add_theme_stylebox_override("background", bg)
	xp_bar.add_theme_stylebox_override("fill", xp_fill)
	
	level_label.add_theme_color_override("font_color", Color("#FBBF24"))

func set_hp(hp: float, max_hp: float) -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = hp

func set_xp(xp: int, xp_to_next: int, level: int) -> void:
	xp_bar.max_value = xp_to_next
	xp_bar.value = xp
	level_label.text = "Lv %d" % level

func set_paused(is_paused: bool) -> void:
	if level_up_panel.visible or game_over_panel.visible:
		return
	pause_panel.visible = is_paused

func show_game_over() -> void:
	pause_panel.visible = false
	level_up_panel.visible = false
	game_over_panel.visible = true

func show_level_up(options: Array) -> void:
	pause_panel.visible = false
	game_over_panel.visible = false
	level_up_panel.visible = true
	for i in range(choice_btns.size()):
		var opt := options[i]
		_choice_ids[i] = opt["id"]
		choice_btns[i].text = "%s\n%s" % [opt["name"], opt["desc"]]

func _choose(index: int) -> void:
	var id := _choice_ids[index]
	level_up_panel.visible = false
	upgrade_chosen.emit(id)
	request_resume.emit()

