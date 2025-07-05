extends PlayerCameraController
class_name PlayerTpsCameraController

@export var player: CharacterBody3D
@export var base: Node3D
@export var shapeCast: ShapeCast3D

var pDelta:float = 0.016


func _physics_process(_delta: float) -> void:
	pDelta = _delta
	handlePlayerFollowing()
	handleCollision()
	pass


func handlePlayerFollowing() -> void:
	base.global_position = lerp(
		base.global_position,
		player.global_position,
		10 * pDelta
		)
	pass


func handleCollision() -> void:
	if(shapeCast.is_colliding()):
		camera.position = shapeCast.target_position * shapeCast.get_closest_collision_safe_fraction()
	else:
		camera.position = shapeCast.target_position
	pass


func onActiveUpdate(_value) -> void:
	base.global_position = player.global_position
	pass
