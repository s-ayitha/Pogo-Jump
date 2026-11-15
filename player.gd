extends CharacterBody2D

signal crashed

signal landed(surface: Node2D)

signal wall_rebounded(wall: Node2D)
@export var launch_pad_boost: float = 150.0

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
	var incoming_velocity := velocity
	
	move_and_slide()

	if is_on_wall_only():
		for index in get_slide_collision_count():
			var collision := get_slide_collision(index)
			var wall := collision.get_collider() as Node2D
			if wall == null or not wall.is_in_group("rebound_wall"):
				continue

			var normal := collision.get_normal()
			if absf(normal.x) > absf(normal.y) and incoming_velocity.x * normal.x < 0.0:
				velocity = Vector2(-incoming_velocity.x, incoming_velocity.y)
				wall_rebounded.emit(wall)
				break

	if is_on_floor():
		if absf(pogo_sprite.rotation_degrees) > max_landing_tilt_degrees:
			has_crashed = true
			velocity = Vector2.ZERO
			crashed.emit()
			return

		velocity = Vector2.UP.rotated(pogo_sprite.rotation) * bounce_speed

		var surface := _get_landing_surface()
		if surface != null:
			if surface.is_in_group("launch_pad"):
				velocity.y -= launch_pad_boost

			print(surface.name, " upward launch speed: ", roundi(-velocity.y))
			landed.emit(surface)
			
func respawn_at(world_position: Vector2) -> void:
	global_position = world_position
	velocity = Vector2.ZERO
	pogo_sprite.rotation = 0.0
	has_crashed = false
	
func _get_landing_surface() -> Node2D:
	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		if collision.get_angle(up_direction) <= floor_max_angle:
			return collision.get_collider() as Node2D

	return null
