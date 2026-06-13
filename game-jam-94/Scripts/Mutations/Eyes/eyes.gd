extends Node2D

@export var SIGHT_RANGE: float = 400.0


func _ready() -> void:
	pass


# Get all things our eyes can see
func get_visible_things() -> Array:
	var space := get_world_2d().direct_space_state
	var hits := _find_objects_radius(space)
	var visible := []
	
	for hit in hits:
		var target = hit.collider
		if _has_los(target.global_position, space):
			visible.append(target)
	
	return visible


# Find all objects visible in a circular radius
func _find_objects_radius(space: PhysicsDirectSpaceState2D) -> Array[Dictionary]:
	var vision_shape := CircleShape2D.new()
	vision_shape.radius = SIGHT_RANGE
	
	var vision_query := PhysicsShapeQueryParameters2D.new()
	vision_query.shape = vision_shape
	vision_query.transform = global_transform
	vision_query.collide_with_areas = true
	
	return space.intersect_shape(vision_query)


# Check if eyes have clear line-of-sight to a target
func _has_los(target: Vector2, space: PhysicsDirectSpaceState2D) -> bool:
	var ray := PhysicsRayQueryParameters2D.create(global_position, target)
	ray.exclude = [get_parent()]
	
	var result := space.intersect_ray(ray)
	return result.is_empty()
