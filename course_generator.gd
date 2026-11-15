extends "res://course.gd"

const SPAWN_AHEAD := 600.0
const RECYCLE_MARGIN := 120.0

@onready var section_a: Node2D = $SectionA
@onready var section_b: Node2D = $SectionB
@onready var goal: Node2D = $GoalPlatform
@onready var camera: Camera2D = $GameCamera

var starting_order: Array[Node2D] = []
var sections: Array[Node2D] = []

func _ready() -> void:
	super._ready()
	var extra_a := section_a.duplicate() as Node2D
	var extra_b := section_b.duplicate() as Node2D
	add_child(extra_a)
	add_child(extra_b)
	starting_order = [section_a, section_b, extra_a, extra_b]
	_reset_sections()

func _process(_delta: float) -> void:
	var highest := sections.back() as Node2D
	var highest_exit := _exit_position(highest)
	if player.global_position.y > highest_exit.y + SPAWN_AHEAD:
		return

	var lowest := sections.front() as Node2D
	var half_view := get_viewport_rect().size.y / (2.0 * camera.zoom.y)
	var visible_bottom := camera.get_screen_center_position().y + half_view
	if _exit_position(lowest).y <= visible_bottom + RECYCLE_MARGIN:
		return

	sections.pop_front()
	_place_section(lowest, highest_exit)
	sections.append(lowest)

func _place_section(section: Node2D, target: Vector2) -> void:
	var entry := section.get_node("EntryPoint") as Marker2D
	section.global_position += target - entry.global_position

func _exit_position(section: Node2D) -> Vector2:
	var marker := section.get_node("ExitPoint") as Marker2D
	return marker.global_position

func _respawn_player() -> void:
	super._respawn_player()
	_reset_sections.call_deferred()

func _reset_sections() -> void:
	sections.assign(starting_order)
	var target := goal.global_position
	for section in sections:
		_place_section(section, target)
		target = _exit_position(section)
