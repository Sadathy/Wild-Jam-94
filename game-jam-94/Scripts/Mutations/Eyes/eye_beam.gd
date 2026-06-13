extends RayCast2D

var in_vision: Node2D = null
var distance_to_seen: float = 0
var sight_range: float = 500


@onready var line: Line2D = $Line

func _physics_process(delta: float) -> void:
	if is_colliding():
		line.set_point_position(1, get_collision_point() - global_position)
		in_vision = get_collider()
		if in_vision.is_in_group("food"):
			line.gradient.set_color(0, Color.GREEN)
			line.gradient.set_color(1, Color.GREEN)
		if in_vision.is_in_group("nav_group"):
			line.gradient.set_color(0, Color.RED)
			line.gradient.set_color(1, Color.RED)
		if in_vision.is_in_group("blobs"):
			line.gradient.set_color(0, Color.BLUE)
			line.gradient.set_color(1, Color.BLUE)
	else:
		line.set_point_position(1, ((target_position - position).normalized()) * sight_range)
		line.gradient.set_color(0, Color.WHITE)
		line.gradient.set_color(1, Color.WHITE)
		in_vision = null
