class_name PlayerCameraHandler
extends Node

@export var context: PlayerContext
@export var pivotStrafe: Marker3D


func _physics_process(_delta: float) -> void:
	pivotStrafe.rotation_degrees.z = context.strafeModule.currentCameraAngle
	pivotStrafe.position.x = context.strafeModule.currentPosOffset.x
	pivotStrafe.position.y = context.strafeModule.currentPosOffset.y
	pass
