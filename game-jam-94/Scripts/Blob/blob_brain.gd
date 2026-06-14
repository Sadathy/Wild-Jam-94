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

@export var BOREDOM_VARIANCE: float = 20
@export var VIGILANCE_VARIANCE: float = 20

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
	current_vigilance += delta * vigilance_factor
	if current_boredom > STATS["boredom"]:
		current_boredom -= STATS["boredom"]
		boredom_factor = randf_range(BOREDOM_VARIANCE * 0.5, BOREDOM_VARIANCE * 1.5)
		on_think()
	if current_vigilance > STATS["vigilance"]:
		current_vigilance -= STATS["vigilance"]
		vigilance_factor = randf_range(VIGILANCE_VARIANCE * 0.5, VIGILANCE_VARIANCE * 1.5)
		on_search()
		
# This updates the visible objects dictionary
func on_search() -> void:
	var visible = []
	if eyes != null:
		visible = eyes.get_visible_things()
	else:
		for key in visible_objects:
			visible_objects[key] = []
		return
	var food = []
	var blobs = []
	var obstacles = []
	
	for thing in visible:
		if thing.is_in_group("food"):
			food.append({
				"object": thing,
				"location": thing.position
			})
		if thing.is_in_group("blobs") and thing != BODY:
			blobs.append({
				"object": thing,
				"location": thing.position
			})
			print(name, " saw a blob!")
		if thing.is_in_group("nav_group"):
			obstacles.append({
				"object": thing,
				"location": thing.position
			})
	
	visible_objects = {
		"food": food,
		"blobs": blobs,
		"obstacles": obstacles
	}
			

func on_think() -> void:
	# If we found food, pick a random food and path towards it. Otherwise, if we have found a blob path away from it. Otherwise path randomly.
	if visible_objects["food"].size() > 0:
		print(name, " is running towards food")
		var chosen_food = visible_objects["food"].pick_random()
		target_location = chosen_food["location"]
		TASK_MANAGER.new_task(TASK_SEEK)
	elif visible_objects["blobs"].size() > 0:
		print(name, " is running from a blob")
		var chosen_blob = visible_objects["blobs"].pick_random()
		var chosen_dir = (BODY.position - chosen_blob["location"]).normalized()
		target_location = BODY.position + (chosen_dir * randf_range(MIN_WANDER_RANGE, MAX_WANDER_RANGE))
		TASK_MANAGER.new_task(TASK_SEEK)
	else:
		print(name, " is resorting to wandering in a random direction")
		var chosen_dir = Vector2.from_angle(randf_range(-PI, PI))
		target_location = BODY.position + (chosen_dir * randf_range(MIN_WANDER_RANGE, MAX_WANDER_RANGE))
		TASK_MANAGER.new_task(TASK_SEEK)
