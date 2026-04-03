class_name PlayerCameraHandler
extends Node

@export var context: PlayerContext
@export var pivotStrafe: Marker3D


func _physics_process(_delta: float) -> void:
	pivotStrafe.rotation_degrees.z = context.strafeModule.state.currentCameraAngle
	pivotStrafe.position.x = context.strafeModule.state.currentPosOffset.x
	pivotStrafe.position.y = context.strafeModule.state.currentPosOffset.y
	pass
