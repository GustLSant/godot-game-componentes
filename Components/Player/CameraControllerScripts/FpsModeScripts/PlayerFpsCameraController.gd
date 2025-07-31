extends PlayerCameraController
class_name PlayerFpsCameraController

@export var pivotPosture: Marker3D
@export var bodyCamera: Camera3D


func _process(_delta: float) -> void:
	super._process(_delta)
	handlePosture()
	bodyCamera.global_transform = camera.global_transform
	pass


func handlePosture() -> void:
	var targetYPos: float = int(playerState.isCrouched) * -0.75
	pivotPosture.position.y = lerp(pivotPosture.position.y, targetYPos, 10.0 * delta)
	pass
