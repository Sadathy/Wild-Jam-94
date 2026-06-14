extends Brain

var target_location: Vector2 = Vector2.ZERO

@export var TASK_SEEK: Task
@export var TASK_IDLE: Task

@export var MAX_WANDER_RANGE: float = 400
@export var MIN_WANDER_RANGE: float = 150

@export var STATS: Dictionary = {
	"boredom": 20,
	"intelligence": 100,
	"toughness": 50,
	"strength": 45,
	"speed": 100
}

var current_boredom: float = 0
var boredom_factor: float = 10
@export var BOREDOM_VARIANCE: float = 20

@onready var eyes: Node2D = %Eyes


func _ready() -> void:
	TASK_SEEK.reached_goal.connect(on_finish_seek)
	print("Stat report for ", name, ":")
	for key in STATS:
		STATS[key] = randi_range(20, 100)
		print(key, ": ", STATS[key])


#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT):
		#target_location = BODY.get_global_mouse_position()
		#TASK_MANAGER.new_task(TASK_SEEK)


func on_finish_seek() -> void:
	TASK_MANAGER.new_task(TASK_IDLE)


func _physics_process(delta: float) -> void:
	current_boredom += delta * boredom_factor
	if current_boredom > STATS["boredom"]:
		current_boredom -= STATS["boredom"]
		boredom_factor = randf_range(BOREDOM_VARIANCE * 0.5, BOREDOM_VARIANCE * 1.5)
		on_think()


func on_think() -> void:
	if TASK_MANAGER.current_task != TASK_IDLE:
		return
	
	var visible = eyes.get_visible_things()
	var food_options = []
	var unblocked_options = []
	
	# Search our eye beams for any food
	for thing in visible:
		if thing.is_in_group("food"): food_options.append(thing)
	
	# If we found food, pick a random food and path towards it. Otherwise path in a random unblocked direction if we can.
	if food_options.size() > 0:
		print("Found at least one food")
		var chosen_food = food_options.pick_random()
		target_location = chosen_food.position
		TASK_MANAGER.new_task(TASK_SEEK)
	elif unblocked_options.size() > 0:
		print("Found an unblocked direction to wander in")
		var chosen_dir = unblocked_options.pick_random()
		target_location = BODY.position + (chosen_dir * randf_range(MIN_WANDER_RANGE, MAX_WANDER_RANGE))
		TASK_MANAGER.new_task(TASK_SEEK)
	else:
		print("Resorting to wandering in a blocked direction")
		var chosen_dir = Vector2.from_angle(randf_range(-PI, PI))
		target_location = BODY.position + (chosen_dir * randf_range(MIN_WANDER_RANGE, MAX_WANDER_RANGE))
		TASK_MANAGER.new_task(TASK_SEEK)
