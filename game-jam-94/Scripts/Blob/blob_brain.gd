extends Brain

var target_location: Vector2 = Vector2.ZERO

@export var TASK_SEEK: Task
@export var TASK_IDLE: Task

@export var MAX_WANDER_RANGE: float = 400
@export var MIN_WANDER_RANGE: float = 150

#STATS AND BEHAVIOUR
@export var STATS: Dictionary = {
	"boredom": 20,
	"vigilance": 20,
}

var visible_objects: Dictionary = {
	"food": [],
	"blobs": [],
	"obstacles": []
}

var current_boredom: float = 0
var boredom_factor: float = 10

var current_vigilance: float = 0
var vigilance_factor: float = 10

var mutations: Array[Mutation] = []

@export var BOREDOM_VARIANCE: float = 20
@export var VIGILANCE_VARIANCE: float = 20

@onready var eyes: Node2D = %Eyes


func _ready() -> void:
	TASK_SEEK.reached_goal.connect(on_finish_seek)
	print("Stat report for ", name, ":")
	for key in STATS:
		STATS[key] = randi_range(20, 100)
		print(key, ": ", STATS[key])
	
	mutations.append(eyes)


#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT):
		#target_location = BODY.get_global_mouse_position()
		#TASK_MANAGER.new_task(TASK_SEEK)


func on_finish_seek() -> void:
	TASK_MANAGER.new_task(TASK_IDLE)


func _physics_process(delta: float) -> void:
	current_boredom += delta * boredom_factor
	current_vigilance += delta * vigilance_factor
	if current_boredom > STATS["boredom"]:
		current_boredom -= STATS["boredom"]
		boredom_factor = randf_range(BOREDOM_VARIANCE * 0.5, BOREDOM_VARIANCE * 1.5)
		on_think()
	if current_vigilance > STATS["vigilance"]:
		current_vigilance -= STATS["vigilance"]
		vigilance_factor = randf_range(VIGILANCE_VARIANCE * 0.5, VIGILANCE_VARIANCE * 1.5)
		on_search()


func on_search() -> void:
	for mutation in mutations:
		mutation.brain_search(self)


func on_think() -> void:
	for mutation in mutations:
		mutation.brain_think(self)
