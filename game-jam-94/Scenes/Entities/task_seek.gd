extends Task

@export var NAV: NavigationAgent2D = null
@export var SPEED: float = 100.0
@export var TASK_IDLE: Task = null
var goal: Vector2 = Vector2.ZERO

func _ready() -> void:
	NAV.navigation_finished.connect(on_reach_goal)

func on_enter() -> void:
	print("goal was: ", goal)
	goal = TASK_MANAGER.BRAIN.target_location
	print("set goal to: ", goal)

func on_physics(delta: float) -> void:
	NAV.target_position = goal
	print("Set NAV target to: ", NAV.target_position)
	var current_pos = TASK_MANAGER.BODY.position
	var target_dir = (NAV.get_next_path_position() - current_pos).normalized()
	TASK_MANAGER.BODY.velocity = (target_dir * SPEED)
	TASK_MANAGER.BODY.move_and_slide()
	
func on_reach_goal() -> void:
	NAV.target_position = TASK_MANAGER.BODY.position
	TASK_MANAGER.new_task(TASK_IDLE)
