extends PlayerModelController
class_name PlayerFpsArmsController

const ARMS_ROT_SPEED:float = 30.0

@export var pivotPosAim: Marker3D
@export var pivotSway: Marker3D
const DEFAULT_POS_AIM: Vector3 = Vector3(0.4, -0.4, -0.2)
const POS_AIMING: Vector3 = Vector3(0.0, -0.175, -0.2)

var delta:float = 0.016


func _process(_delta: float) -> void:
	delta = _delta
	handleRotation()
	handleAimBehaviour()
	handleSwayEffect()
	pass


func handleRotation() -> void:
	pivotRot.global_rotation.y = lerp_angle(pivotRot.global_rotation.y, playerState.currentPivotRot.global_rotation.y, ARMS_ROT_SPEED*delta)
	pivotRot.global_rotation.x = lerp_angle(pivotRot.global_rotation.x, playerState.currentPivotRot.global_rotation.x, ARMS_ROT_SPEED*delta)
	pass


func handleAimBehaviour() -> void:
	var targetPos: Vector3 = int(playerState.isAiming) * POS_AIMING + int(not playerState.isAiming) * DEFAULT_POS_AIM
	pivotPosAim.position = lerp(pivotPosAim.position, targetPos, 10.0 * delta)
	pass


func handleSwayEffect()->void:
	var playerIsMoving: bool = playerState.player.velocity.x != 0.0 or playerState.player.velocity.z != 0.0
	const SWAY_IDLE_FREQUENCY:float = 0.0025
	const SWAY_WALKING_FREQUENCY:float = 0.0125
	const SWAY_IDLE_AMOUNT:float = 0.02
	const SWAY_WALKING_AMOUNT:float = 0.075
	
	var frequence:float = (
		SWAY_IDLE_FREQUENCY * int(!playerIsMoving) +
		SWAY_WALKING_FREQUENCY * int(playerIsMoving) +
		SWAY_WALKING_FREQUENCY * int(playerIsMoving and playerState.isSprinting)
	)
	var amount:float = (
		SWAY_IDLE_AMOUNT * int(!playerIsMoving) +
		SWAY_WALKING_AMOUNT * int(playerIsMoving) +
		SWAY_WALKING_AMOUNT * int(playerIsMoving and playerState.isSprinting)
	)
	
	# redução do efeito ao mirar
	frequence *= (0.5 * int(playerState.isAiming)) + (1.0 * int(!playerState.isAiming))
	amount *= (0.5 * int(playerState.isAiming)) + (1.0 * int(!playerState.isAiming))
	
	pivotSway.position.x = lerp(pivotSway.position.x, sin(Time.get_ticks_msec()*frequence*0.5)*amount, 10*delta)
	pivotSway.position.y = lerp(pivotSway.position.y, sin(Time.get_ticks_msec()*frequence)*amount, 10*delta)
	pass
