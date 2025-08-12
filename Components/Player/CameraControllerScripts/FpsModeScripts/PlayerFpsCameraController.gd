extends PlayerCameraController
class_name PlayerFpsCameraController

@export var pivotPosture: Marker3D
@export var bodyCamera: Camera3D


func _process(_delta: float) -> void:
	super._process(_delta)
	handlePosture()
	pass


func handlePosture() -> void:
	var targetYPos: float = int(player.isCrouched) * player.CROUCH_HEIGHT
	pivotPosture.position.y = lerp(pivotPosture.position.y, targetYPos, player.CROUCH_SPEED * delta)
	pass


func handleAimBehaviour() -> void:
	var targetGeneralFOV:float = int(player.isAiming) * player.aimFOV + int(not player.isAiming) * Settings.defaultFOV
	var targetBodyFOV:float = int(player.isAiming) * (Settings.defaultFOV - 5.0) + int(not player.isAiming) * Settings.defaultFOV
	camera.fov = lerp(camera.fov, targetGeneralFOV, 10.0*delta)
	bodyCamera.fov = lerp(camera.fov, targetBodyFOV, 10.0*delta)
	pass
