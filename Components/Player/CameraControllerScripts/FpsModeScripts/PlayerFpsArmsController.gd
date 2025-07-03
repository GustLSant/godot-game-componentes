extends Node3D
class_name PlayerFpsArmsController

const ARMS_ROT_SPEED:float = 30.0
@export var fpsCamera: PlayerFpsCameraController
@export var playerCombatController: PlayerCombatController

@export_category("Internal Variables")
@export var pivotRot: Marker3D
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
	var targetPos: Vector3 = int(playerCombatController.isAiming) * POS_AIMING + int(not playerCombatController.isAiming) * DEFAULT_POS_AIM
	pivotPosAim.position = lerp(pivotPosAim.position, targetPos, 10.0 * delta)
	pass


func setActive(_value: bool, _rotation: Vector3 = Vector3.ZERO) -> void:
	set_process(_value)
	set_physics_process(_value)
	self.visible = _value
	pivotRot.rotation = _rotation
	pass
