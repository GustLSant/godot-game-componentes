extends PlayerCameraController
class_name PlayerFpsCameraController

@export var bodyCamera: Camera3D

func _process(_delta: float) -> void:
	super._process(_delta)
	bodyCamera.global_transform = camera.global_transform
	pass
