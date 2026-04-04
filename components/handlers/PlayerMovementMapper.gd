class_name PlayerMovementMapper
extends Node

@export var manager: PlayerManager
@export var player: CharacterBody3D


func _physics_process(_delta: float) -> void:
	player.velocity = Vector3.ZERO
	
	$"../../StandingCollider".disabled = manager.crouchModule.isCrouched or manager.diveModule.isDiving
	$"../../CrouchCollider".disabled = not manager.crouchModule.isCrouched
	$"../../DiveCollider".disabled = not manager.diveModule.isDiving
	
	$"../../DiveCollider".shape.size = manager.diveModule.currentColliderSize
	$"../../DiveCollider".position.y = manager.diveModule.currentColliderHeight
	
	player.velocity += manager.fpsWalkModule.walkVec
	
	player.velocity *= manager.sprintModule.speedMultiplier
	player.velocity *= manager.crouchModule.speedMultiplier
	player.velocity *= manager.strafeModule.speedMultiplier
	
	player.velocity.y += manager.jumpModule.motion
	player.velocity += manager.diveModule.motion
	
	player.velocity.y += manager.gravityModule.motion
	
	player.move_and_slide()
	pass
