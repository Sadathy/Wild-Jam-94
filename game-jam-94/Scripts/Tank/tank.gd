extends Node2D

@export var MAX_X: float = 1000
@export var MIN_X: float = -1000
@export var MAX_Y: float = 500
@export var MIN_Y: float = -500

@onready var tank_boundary: Polygon2D = %TankBoundary
@onready var tank_camera: Camera2D = %TankCamera

func _ready() -> void:
	var boundary_array: PackedVector2Array
	boundary_array.append(Vector2(MIN_X, MIN_Y))
	boundary_array.append(Vector2(MAX_X, MIN_Y))
	boundary_array.append(Vector2(MAX_X, MAX_Y))
	boundary_array.append(Vector2(MIN_X, MAX_Y))
	
	tank_boundary.polygon = boundary_array
	tank_boundary.uv = boundary_array
	
	tank_camera.MAX_X = MAX_Y
	tank_camera.MIN_Y = MIN_Y
	tank_camera.MIN_X = MIN_X
	tank_camera.MAX_X = MAX_X
