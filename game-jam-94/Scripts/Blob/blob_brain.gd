extends Brain

var target_location: Vector2 = Vector2.ZERO

@export var TASK_SEEK: Task
@export var TASK_IDLE: Task

func _ready() -> void:
	TASK_SEEK.reached_goal.connect(on_finish_seek)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT):
		target_location = BODY.get_global_mouse_position()
		TASK_MANAGER.new_task(TASK_SEEK)

func on_finish_seek() -> void:
	TASK_MANAGER.new_task(TASK_IDLE)
