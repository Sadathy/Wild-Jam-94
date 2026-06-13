class_name TaskManager extends Node

@export var DEFAULT_TASK: Task = null
@export var BRAIN: Brain = null
@export var BODY: CharacterBody2D = null

var current_task: Task = null

func _physics_process(delta: float) -> void:
	current_task.on_physics(delta)

func _process(delta: float) -> void:
	current_task.on_frame(delta)

func _ready() -> void:
	current_task = DEFAULT_TASK
	
func new_task(next_task: Task) -> void:
	print("Leaving task: ", current_task)
	current_task.on_exit()
	current_task = next_task
	print("Entering task: ", current_task)
	current_task.on_enter()
