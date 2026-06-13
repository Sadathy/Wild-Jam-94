extends Camera2D

@export var SENSITIVITY: float = 100.0
@export var HOLD_EFFECT: float = 400.0

var hold_time: float = 0
const HOLD_MAX: float = 2.0

var MAX_X: float = 0
var MIN_X: float = 0
var MAX_Y: float = 0
var MIN_Y: float = 0

func _process(delta: float) -> void:
	var input_dir = Input.get_vector("left", "right", "up", "down")
	if input_dir != Vector2.ZERO:
		position += input_dir * ((SENSITIVITY + ((hold_time / HOLD_MAX) * HOLD_EFFECT)) * delta)
		hold_time += delta
		if hold_time > HOLD_MAX: hold_time = HOLD_MAX
	else:
		hold_time = 0
	position.x = clamp(position.x, MIN_X, MAX_X)
	position.y = clamp(position.y, MIN_Y, MAX_Y)
