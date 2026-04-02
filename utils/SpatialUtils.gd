class_name SpatialUtils
extends Node


func getDistanceFromNearestCollision(_node3d: Node3D, _direction: Vector3, _maxDistance: float = 10.0, _collMask: int = 1) -> float:
	var space: PhysicsDirectSpaceState3D = _node3d.get_world_3d().direct_space_state
	
	var origin: Vector3 = _node3d.global_transform.origin
	var to: Vector3 = origin + (_direction * _maxDistance)
	
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, to)
	query.collide_with_bodies = true
	query.collide_with_areas = false
	query.collision_mask = _collMask
	
	var result: Dictionary = space.intersect_ray(query)
	
	if result.is_empty(): return -1.0
	else: return origin.distance_to(result.position)
