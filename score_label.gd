extends CanvasLayer

@onready var player: Node2D = $"../Course/Player"
@onready var start_y: float = $"../Course/StartMarker".global_position.y
@onready var score_label: Label = $ScoreLabel

var high_score := 0

func _ready() -> void:
	score_label.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	score_label.offset_left = -340.0
	score_label.offset_right = -20.0
	score_label.offset_top = 16.0
	score_label.offset_bottom = 56.0
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	score_label.add_theme_color_override("font_color", Color.BLACK)
	score_label.add_theme_font_size_override("font_size", 28)
	score_label.text = "HIGH SCORE  0"

func _physics_process(_delta: float) -> void:
	var height := floori(start_y - player.global_position.y)
	if height > high_score:
		high_score = height
		score_label.text = "HIGH SCORE  %d" % high_score
