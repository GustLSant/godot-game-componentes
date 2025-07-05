extends PlayerModelController
class_name PlayerFpsArmsController

const ARMS_ROT_SPEED:float = 30.0
@export var fpsCamera: PlayerFpsCameraController

@export_category("Internal Variables")
@export var pivotPosAim: Marker3D
const DEFAULT_POS_AIM: Vector3 = Vector3(0.4, -0.4, -0.2)
const POS_AIMING: Vector3 = Vector3(0.0, -0.175, -0.2)

var delta:float = 0.016


func _process(_delta: float) -> void:
	delta = _delta
	handleRotation()
	handleAimBehaviour()
	pass


func handleRotation() -> void:
	pivotRot.global_rotation.y = lerp_angle(pivotRot.global_rotation.y, fpsCamera.pivotRot.global_rotation.y, ARMS_ROT_SPEED*delta)
	pivotRot.global_rotation.x = lerp_angle(pivotRot.global_rotation.x, fpsCamera.pivotRot.global_rotation.x, ARMS_ROT_SPEED*delta)
	pass


func handleAimBehaviour() -> void:
	var targetPos: Vector3 = int(playerState.isAiming) * POS_AIMING + int(not playerState.isAiming) * DEFAULT_POS_AIM
	pivotPosAim.position = lerp(pivotPosAim.position, targetPos, 10.0 * delta)
	pass
