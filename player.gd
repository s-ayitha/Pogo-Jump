extends CharacterBody2D

signal crashed

@export var gravity_strength: float = 1200.0
@export var bounce_speed: float = 1000.0
@export var turn_speed_degrees: float = 180.0
@export var max_landing_tilt_degrees: float = 70.0

@onready var pogo_sprite: Sprite2D = $Sprite2D

var has_crashed := false

func _physics_process(delta: float) -> void:
	if has_crashed:
		return

	var turn := Input.get_axis("rotate_left", "rotate_right")
	pogo_sprite.rotation_degrees = wrapf(
		pogo_sprite.rotation_degrees + turn * turn_speed_degrees * delta,
		-180.0,
		180.0
	)

	velocity.y += gravity_strength * delta
	move_and_slide()

	if is_on_floor():
		if absf(pogo_sprite.rotation_degrees) > max_landing_tilt_degrees:
			has_crashed = true
			velocity = Vector2.ZERO
			crashed.emit()
			return

		velocity = Vector2.UP.rotated(pogo_sprite.rotation) * bounce_speed

func respawn_at(world_position: Vector2) -> void:
	global_position = world_position
	velocity = Vector2.ZERO
	pogo_sprite.rotation = 0.0
	has_crashed = false
