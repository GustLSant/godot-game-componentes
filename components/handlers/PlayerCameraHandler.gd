class_name PlayerCameraHandler
extends Node

@export var context: PlayerContext
@export var camera: Node3D
@export var pivotStrafe: Marker3D


func _physics_process(_delta: float) -> void:
	camera.position.y = context.crouchController.state.heightOffset
	pivotStrafe.rotation_degrees.z = context.strafeController.state.currentCameraAngle
	pivotStrafe.position.x = context.strafeController.state.currentPosOffset.x
	pivotStrafe.position.y = context.strafeController.state.currentPosOffset.y
	pass
