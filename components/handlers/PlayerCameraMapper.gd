class_name PlayerCameraMapper
extends Node

@export var manager: PlayerManager
@export var pivotRot: Marker3D
@export var pivotStrafe: Marker3D
@export var pivotCrouch: Marker3D


func _physics_process(_delta: float) -> void:
	pivotRot.rotation_degrees = manager.fpsCameraRotModule.targetRotation
	
	pivotCrouch.position.y = manager.crouchModule.heightOffset
	
	pivotStrafe.rotation_degrees.z = manager.strafeModule.currentCameraAngle
	pivotStrafe.position.x = manager.strafeModule.currentPosOffset.x
	pivotStrafe.position.y = manager.strafeModule.currentPosOffset.y
	pass
