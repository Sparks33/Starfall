extends Area2D

const FIELD_LEFT := 28.0
const FIELD_RIGHT := 1124.0
const FIELD_TOP := 28.0
const FIELD_BOTTOM := 620.0

var bounce_direction := Vector2.RIGHT
var bounce_speed := 90.0

func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	bounce_direction = Vector2.RIGHT.rotated(rng.randf_range(0.0, TAU))
	bounce_speed = rng.randf_range(75.0, 110.0)

func _physics_process(delta: float) -> void:
	var next_position := position + bounce_direction * bounce_speed * delta
	if next_position.x < FIELD_LEFT or next_position.x > FIELD_RIGHT:
		bounce_direction.x *= -1.0
		next_position.x = clampf(next_position.x, FIELD_LEFT, FIELD_RIGHT)
	if next_position.y < FIELD_TOP or next_position.y > FIELD_BOTTOM:
		bounce_direction.y *= -1.0
		next_position.y = clampf(next_position.y, FIELD_TOP, FIELD_BOTTOM)
	position = next_position
