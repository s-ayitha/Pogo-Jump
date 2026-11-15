extends CharacterBody2D

@export var gravity_strength: float = 1200.0
@export var bounce_speed: float = 750.0
@export var turn_speed_degrees: float = 180
@export var max_tilt_degrees: float = 40.0

@onready var pogo_sprite: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	var turn := Input.get_axis("rotate_left", "rotate_right")
	pogo_sprite.rotation_degrees = clampf(
		pogo_sprite.rotation_degrees + turn * turn_speed_degrees * delta,
		-max_tilt_degrees,
		max_tilt_degrees
	)
	
	velocity.y += gravity_strength * delta
	move_and_slide()
	
	if is_on_floor():
		velocity = Vector2.UP.rotated(pogo_sprite.rotation) * bounce_speed
