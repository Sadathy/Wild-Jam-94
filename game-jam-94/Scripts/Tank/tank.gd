extends Node2D

@export var MAX_X: float = 650
@export var MIN_X: float = -650
@export var MAX_Y: float = 350
@export var MIN_Y: float = -350

@onready var tank_boundary: Polygon2D = %TankBoundary
@onready var tank_camera: Camera2D = %TankCamera

const FOOD = preload("uid://bmakpnqlsin58")

const FOOD_INTERVAL: float = 6.0
const MAX_FOOD: int = 40
var food_timer: float = 1.0

func _ready() -> void:
	var boundary_array: PackedVector2Array
	boundary_array.append(Vector2(MIN_X, MIN_Y))
	boundary_array.append(Vector2(MAX_X, MIN_Y))
	boundary_array.append(Vector2(MAX_X, MAX_Y))
	boundary_array.append(Vector2(MIN_X, MAX_Y))
	
	tank_boundary.polygon = boundary_array
	tank_boundary.uv = boundary_array
	
	tank_camera.MAX_X = MAX_X
	tank_camera.MIN_Y = MIN_Y
	tank_camera.MIN_X = MIN_X
	tank_camera.MAX_Y = MAX_Y
	
func _physics_process(delta: float) -> void:
	food_timer -= delta
	if food_timer <= 0 and get_tree().get_nodes_in_group("food").size() < MAX_FOOD:
		food_timer += FOOD_INTERVAL
		var new_food = FOOD.instantiate()
		new_food.position.x = randf_range(MIN_X + 50, MAX_X - 50)
		new_food.position.y = randf_range(MIN_Y + 50, MAX_Y - 50)
		new_food.position = NavigationServer2D.map_get_closest_point(get_world_2d().navigation_map, new_food.position)
		new_food.food_eaten.connect(on_food_eaten)
		new_food.add_to_group("food")
		add_child(new_food)

func on_food_eaten(body: Node2D) -> void:
	print("A piece of food was eaten by: ", body)
