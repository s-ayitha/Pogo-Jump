extends Node2D

@export var fall_y: float = 1050.0

@onready var player = $Player
@onready var start_marker: Marker2D = $StartMarker

func _ready() -> void:
	player.crashed.connect(_respawn_player)

func _physics_process(_delta: float) -> void:
	if player.position.y > fall_y:
		_respawn_player()

func _respawn_player() -> void:
	player.call_deferred("respawn_at", start_marker.global_position)
