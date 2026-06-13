extends Task

@export var NAV: NavigationAgent2D = null
@export var SPEED: float = 100.0

var goal: Vector2 = Vector2.ZERO

signal reached_goal

func _ready() -> void:
	NAV.navigation_finished.connect(on_reach_goal)

func on_enter() -> void:
	goal = TASK_MANAGER.BRAIN.target_location

func on_physics(delta: float) -> void:
	NAV.target_position = goal
	var current_pos = TASK_MANAGER.BODY.position
	var target_dir = (NAV.get_next_path_position() - current_pos).normalized()
	TASK_MANAGER.BODY.velocity = (target_dir * SPEED)
	TASK_MANAGER.BODY.move_and_slide()
	
func on_reach_goal() -> void:
	NAV.target_position = TASK_MANAGER.BODY.position
	reached_goal.emit()
