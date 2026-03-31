class_name PlayerCameraContext
extends Node

@export var fpsCameraRotController: FpsCameraRotController

@export var pivotRot: Node3D

func _process(_delta: float) -> void:
	fpsCameraRotController.run(pivotRot, Settings.cameraSensitivity, Settings.cameraSensitivity, 200.0, 200.0, _delta)
	pass
