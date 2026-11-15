extends Camera2D

@export var follow_speed: float = 4.0
@onready var player: Node2D = get_parent().get_node("Player")

var highest_y: float

func _ready() -> void:
	highest_y = global_position.y

func _process(delta: float) -> void:
	if player.global_position.y < highest_y:
		highest_y = player.global_position.y

	global_position.y = lerp(
		global_position.y,
		highest_y,
		1.0 - exp(-follow_speed * delta)
	)
