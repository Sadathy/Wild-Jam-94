extends Brain

var target_location: Vector2 = Vector2.ZERO

@export var TASK_SEEK: Task

func _process(delta: float) -> void:
	target_location = BODY.get_global_mouse_position()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT):
		print("detected mouse click")
		target_location = BODY.get_global_mouse_position()
		print("set target location to: ", target_location)
		TASK_MANAGER.new_task(TASK_SEEK)
