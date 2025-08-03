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
	var targetYPos: float = int(playerState.isCrouched) * playerState.CROUCH_HEIGHT
	pivotPosture.position.y = lerp(pivotPosture.position.y, targetYPos, playerState.CROUCH_SPEED * delta)
	pass


func handleAimBehaviour() -> void:
	var targetGeneralFOV:float = int(playerState.isAiming) * playerState.aimFOV + int(not playerState.isAiming) * Settings.defaultFOV
	var targetBodyFOV:float = int(playerState.isAiming) * (Settings.defaultFOV - 5.0) + int(not playerState.isAiming) * Settings.defaultFOV
	camera.fov = lerp(camera.fov, targetGeneralFOV, 10.0*delta)
	bodyCamera.fov = lerp(camera.fov, targetBodyFOV, 10.0*delta)
	pass
