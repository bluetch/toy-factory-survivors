extends Control

signal start_pressed
signal quit_pressed

@onready var _start_btn: Button = %Start
@onready var _quit_btn: Button = %Quit
@onready var _panel: PanelContainer = %Panel
@onready var _title: Label = %Title
@onready var _subtitle: Label = %Subtitle

func _ready() -> void:
	_apply_factory_ui()
	_start_btn.pressed.connect(func(): start_pressed.emit())
	_quit_btn.pressed.connect(func(): quit_pressed.emit())

func _apply_factory_ui() -> void:
	var btn := func(b: Button, accent: Color) -> void:
		var normal := StyleBoxFlat.new()
		normal.bg_color = Color("#10192f")
		normal.border_width_left = 2
		normal.border_width_top = 2
		normal.border_width_right = 2
		normal.border_width_bottom = 2
		normal.border_color = accent
		normal.corner_radius_top_left = 6
		normal.corner_radius_top_right = 6
		normal.corner_radius_bottom_left = 6
		normal.corner_radius_bottom_right = 6
		normal.content_margin_left = 16
		normal.content_margin_right = 16
		normal.content_margin_top = 12
		normal.content_margin_bottom = 12
		
		var hover := normal.duplicate()
		hover.bg_color = Color("#162449")
		
		var pressed := normal.duplicate()
		pressed.bg_color = Color("#0b1224")
		pressed.border_color = accent.lightened(0.15)
		
		b.add_theme_stylebox_override("normal", normal)
		b.add_theme_stylebox_override("hover", hover)
		b.add_theme_stylebox_override("pressed", pressed)
		b.add_theme_color_override("font_color", Color("#E5E7EB"))
		b.add_theme_color_override("font_hover_color", Color("#F9FAFB"))
		b.add_theme_color_override("font_pressed_color", Color("#FDE68A"))
	
	btn.call(_start_btn, Color("#FBBF24"))
	btn.call(_quit_btn, Color("#60A5FA"))
	
	_title.add_theme_color_override("font_color", Color("#FBBF24"))
	_subtitle.add_theme_color_override("font_color", Color("#C7D2FE"))

