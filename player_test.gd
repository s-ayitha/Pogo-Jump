extends Node2D

@onready var player = $Player
@onready var spawn_position: Vector2 = player.global_position

func _ready() -> void:
	player.crashed.connect(_on_player_crashed)
	
func _on_player_crashed() -> void:
	player.call_deferred("respawn_at", spawn_position)
	
