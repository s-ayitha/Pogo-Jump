extends Camera2D

@onready var player: Node2D = $"../Player"

func _process(_delta: float) -> void:
	global_position = player.global_position
