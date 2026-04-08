class_name PlayerArmsMapper
extends Node

@export var playerManager: PlayerManager
@export var pivotAimPos: Marker3D

func _physics_process(_delta: float) -> void:
	pivotAimPos.position = Vector3(0.4, 0.0, 0.0) * (1.0 - playerManager.aimModule.aimFactor) + Vector3(0.0, 0.25, 0.0) * playerManager.aimModule.aimFactor
	pass
