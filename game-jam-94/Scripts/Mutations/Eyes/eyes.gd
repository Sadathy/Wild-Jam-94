extends Node2D

@export var SIGHT_RANGE: float = 400.0

const BEAM_COUNT: int = 16
const EYE_BEAM = preload("uid://fwjwh0yjcmg0")

var eye_data: Dictionary = {}

func _ready() -> void:
	construct_eye_beams()
	read_eye_beams()

func construct_eye_beams() -> void:
	for i in BEAM_COUNT:
		var new_beam = EYE_BEAM.instantiate()
		var direction = Vector2.from_angle((TAU/BEAM_COUNT) * i)
		new_beam.target_position = direction * SIGHT_RANGE
		new_beam.sight_range = SIGHT_RANGE
		eye_data[i] = {
			"eye_beam": new_beam,
			"direction": direction
		}
		add_child(new_beam)

func read_eye_beams() -> Dictionary:
	var return_data = {}
	for i in BEAM_COUNT:
		var reading_eye = eye_data[i]["eye_beam"]
		return_data[i] = {
			"in_vision": reading_eye.in_vision,
			"direction": eye_data[i]["direction"]
			}
	return return_data
