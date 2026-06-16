extends CharacterBody2D

var acceleration: float = 0.5
var shader_velocity := Vector2.ZERO

func _ready() -> void:
	#duplicates the material so it's unique for each blob :)
	get_node("Blob_Base").material = get_node("Blob_Base").material.duplicate()

func _physics_process(delta: float) -> void:
	
	if velocity.length() < 1.0:
		acceleration = 1.0
	else: acceleration = 0.5;
	
	#changes acceleration to stopping smoothly
	shader_velocity = shader_velocity.lerp((velocity/300), acceleration * delta)
	
	#sends velocity info to shader
	get_node("Blob_Base").material.set_shader_parameter("blob_velocity", shader_velocity)
