extends Mutation

@export var SIGHT_RANGE: float = 400.0


# Search for things we can see and add to brain's visible_objects
func brain_search(brain: Brain) -> void:
	var visible = _get_visible_things()

	var food = []
	var blobs = []
	var obstacles = []
	
	for thing in visible:
		if thing.is_in_group("food"):
			food.append({
				"object": thing,
				"location": thing.position
			})
		elif thing.is_in_group("blobs") and thing != brain.BODY:
			blobs.append({
				"object": thing,
				"location": thing.position
			})
			print(name, " saw a blob!")
		elif thing.is_in_group("nav_group"):
			obstacles.append({
				"object": thing,
				"location": thing.position
			})
	
	brain.visible_objects = {
		"food": food,
		"blobs": blobs,
		"obstacles": obstacles
	}


# If we found food, pick a random food and path towards it. Otherwise, if we have found a blob path away from it. Otherwise path randomly.
func brain_think(brain: Brain) -> void:
	if brain.visible_objects["food"].size() > 0:
		print(name, " is running towards food")
		var chosen_food = brain.visible_objects["food"].pick_random()
		brain.target_location = chosen_food["location"]
		brain.TASK_MANAGER.new_task(brain.TASK_SEEK)
	elif brain.visible_objects["blobs"].size() > 0:
		print(name, " is running from a blob")
		var chosen_blob = brain.visible_objects["blobs"].pick_random()
		var chosen_dir = (brain.BODY.position - chosen_blob["location"]).normalized()
		brain.target_location = brain.BODY.position + (chosen_dir * randf_range(brain.MIN_WANDER_RANGE, brain.MAX_WANDER_RANGE))
		brain.TASK_MANAGER.new_task(brain.TASK_SEEK)
	else:
		print(name, " is resorting to wandering in a random direction")
		var chosen_dir = Vector2.from_angle(randf_range(-PI, PI))
		brain.target_location = brain.BODY.position + (chosen_dir * randf_range(brain.MIN_WANDER_RANGE, brain.MAX_WANDER_RANGE))
		brain.TASK_MANAGER.new_task(brain.TASK_SEEK)


# Get all things our eyes can see
func _get_visible_things() -> Array:
	var space := get_world_2d().direct_space_state
	var hits := _find_objects_radius(space)
	var visible := []
	
	for hit in hits:
		var target = hit.collider
		if _has_los(target, space):
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
	vision_query.collide_with_bodies = true
	vision_query.exclude = [get_parent().get_rid()]
	
	return space.intersect_shape(vision_query)


# Check if eyes have clear line-of-sight to a target
func _has_los(target: Node2D, space: PhysicsDirectSpaceState2D) -> bool:
	var ray := PhysicsRayQueryParameters2D.create(global_position, target.global_position)
	ray.exclude = [get_parent().get_rid(), target.get_rid()]
	
	var result := space.intersect_ray(ray)
	return result.is_empty()
