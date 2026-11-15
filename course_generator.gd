
extends Node2D

@export var section_height: float = 900.0

@onready var player: CharacterBody2D = $Player
@onready var section_a: Node2D = $SectionA
@onready var section_b: Node2D = $SectionB

var next_section_to_move: Node2D
var generation_threshold: float


func _ready() -> void:
	next_section_to_move = section_a
	generation_threshold = section_b.global_position.y + section_height / 2.0


func _process(_delta: float) -> void:
	if player.global_position.y < generation_threshold:
		recycle_section()


func recycle_section() -> void:
	if next_section_to_move == section_a:
		section_a.global_position.y = section_b.global_position.y - section_height
		next_section_to_move = section_b
	else:
		section_b.global_position.y = section_a.global_position.y - section_height
		next_section_to_move = section_a

	generation_threshold -= section_height
