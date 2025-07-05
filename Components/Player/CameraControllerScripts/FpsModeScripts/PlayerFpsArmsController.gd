extends PlayerModelController
class_name PlayerFpsArmsController

const ARMS_ROT_SPEED: float = 15.0
const ARMS_AIM_ROT_SPEED: float = 40.0

@export var pivotSway: Marker3D
@export var pivotTilt: Marker3D
@export var pivotRecoil: Marker3D
@export var pivotPosAim: Marker3D

@export var recoilCurve: Curve
var recoilOffset: float = 0.0
var recoilRotZSide: float = 1.0

const DEFAULT_POS_AIM: Vector3 = Vector3(0.4, -0.4, -0.2)
const POS_AIMING: Vector3 = Vector3(0.0, -0.175, -0.2)

var delta:float = 0.016


func _process(_delta: float) -> void:
	delta = _delta
	handleRotation()
	handleAimBehaviour()
	handleSwayEffect()
	handleTiltEffect()
	handleRecoilEffect()
	pass


func handleRotation() -> void:
	var speed: float = int(playerState.isAiming) * ARMS_AIM_ROT_SPEED + int(not playerState.isAiming) * ARMS_ROT_SPEED
	speed = speed * delta
	speed = min(speed, 1.0)
	pivotRot.global_rotation.y = lerp_angle(pivotRot.global_rotation.y, playerState.currentPivotRot.global_rotation.y, speed)
	pivotRot.global_rotation.x = lerp_angle(pivotRot.global_rotation.x, playerState.currentPivotRot.global_rotation.x, speed)
	pass


func handleAimBehaviour() -> void:
	var targetPos: Vector3 = int(playerState.isAiming) * POS_AIMING + int(not playerState.isAiming) * DEFAULT_POS_AIM
	pivotPosAim.position = lerp(pivotPosAim.position, targetPos, 10.0 * delta)
	pass


func handleSwayEffect() -> void:
	var playerIsMoving: bool = playerState.player.velocity.x != 0.0 or playerState.player.velocity.z != 0.0
	const SWAY_IDLE_FREQUENCY:float = 0.0025
	const SWAY_WALKING_FREQUENCY:float = 0.01
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
	
	var isPlayerOnFloor: bool = playerState.player.is_on_floor()
	var targetSwayPosition: Vector3 = Vector3(
		sin(Time.get_ticks_msec()*frequence*0.5)*amount,
		sin(Time.get_ticks_msec()*frequence)*amount,
		0.0
	)
	var finalPosition = int(isPlayerOnFloor) * targetSwayPosition + int(not isPlayerOnFloor) * pivotSway.position
	
	pivotSway.position = lerp(pivotSway.position, finalPosition, 10 * delta)
	#pivotSway.position.x = lerp(pivotSway.position.x, sin(Time.get_ticks_msec()*frequence*0.5)*amount, 10*delta)
	#pivotSway.position.y = lerp(pivotSway.position.y, sin(Time.get_ticks_msec()*frequence)*amount, 10*delta)
	pass


func handleTiltEffect() -> void:
	const TILT_SPEED: float = 7.5
	var targetRotationZ: float = playerState.inputVecMovement.x * -7.5
	var targetRotationX: float = playerState.inputVecMovement.y * 2.5
	
	targetRotationZ *= int(playerState.isAiming) * 0.5 + int(not playerState.isAiming) * 1.0
	targetRotationX *= int(playerState.isAiming) * 0.5 + int(not playerState.isAiming) * 1.0
	
	pivotTilt.rotation_degrees.z = lerp(pivotTilt.rotation_degrees.z, targetRotationZ, TILT_SPEED * delta)
	pivotTilt.rotation_degrees.x = lerp(pivotTilt.rotation_degrees.x, targetRotationX, TILT_SPEED * delta)
	pass


func handleRecoilEffect() -> void:	
	pivotRecoil.position.z = recoilCurve.sample_baked(recoilOffset) * 0.25 * playerState.recoilPosZStrength
	
	pivotRecoil.rotation.x = recoilCurve.sample_baked(recoilOffset) * 0.05 * playerState.recoilRotXStrength
	pivotRecoil.rotation.z = recoilCurve.sample_baked(recoilOffset) * -0.05 * recoilRotZSide * playerState.recoilRotZStrength
	
	recoilOffset = lerp(recoilOffset, 0.0, 10.0 * delta)
	pass


func addRecoil() -> void:
	recoilOffset = 1.0
	pass


func onPlayerShot(_recoilStrength: float) -> void:
	addRecoil()
	recoilRotZSide = [1, -1].pick_random()
	pass
