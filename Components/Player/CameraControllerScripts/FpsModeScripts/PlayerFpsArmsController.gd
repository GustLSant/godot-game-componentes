extends PlayerModelController
class_name PlayerFpsArmsController

const ARMS_ROT_SPEED: float = 25.0
const ARMS_AIM_ROT_SPEED: float = 40.0

@export var pivotSway: Marker3D
@export var pivotTilt: Marker3D
@export var pivotPosture: Marker3D
@export var pivotRecoil: Marker3D
@export var pivotPosAim: Marker3D

@export var recoilCurve: Curve
var recoilOffset: float = 0.0
var recoilRotZSide: float = 1.0

var delta:float = 0.016


func _ready() -> void:
	super._ready()
	playerState.connect("PickupWeapon", onPickupWeapon)
	pass


func _process(_delta: float) -> void:
	delta = _delta
	handleRotation()
	handleAimBehaviour()
	handleSwayEffect()
	handleTiltEffect()
	handlePostureEffect()
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
	var targetPos: Vector3 = int(playerState.isAiming) * playerState.armsAimPosition + int(not playerState.isAiming) * playerState.armsDefaultPosition
	pivotPosAim.position = lerp(pivotPosAim.position, targetPos, 10.0 * delta)
	pass


func handleSwayEffect() -> void:
	var playerIsMoving: bool = Nodes.player.velocity.x != 0.0 or Nodes.player.velocity.z != 0.0
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
	
	var targetSwayPosition: Vector3 = Vector3(
		sin(Time.get_ticks_msec()*frequence*0.5)*amount,
		sin(Time.get_ticks_msec()*frequence)*amount,
		0.0
	)
	
	# cancelamento do efeito quando estiver no ar
	var finalPosition = int(playerState.isOnFloor) * targetSwayPosition + int(not playerState.isOnFloor) * pivotSway.position
	
	pivotSway.position = lerp(pivotSway.position, finalPosition, 10 * delta)
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


func handlePostureEffect() -> void:
	var targetXRotation:float = int(playerState.isSprinting) * -10.0
	var targetYRotation:float = int(playerState.isSprinting) * 15.0
	var targetYPosition: float = int(not playerState.isOnFloor) * 0.2 - int(not playerState.isOnFloor and playerState.isAiming) * 0.15
	
	pivotPosture.rotation_degrees.x = lerp(pivotPosture.rotation_degrees.x, targetXRotation, 10.0 * delta)
	pivotPosture.rotation_degrees.y = lerp(pivotPosture.rotation_degrees.y, targetYRotation, 10.0 * delta)
	pivotPosture.position.y = lerp(pivotPosture.position.y, targetYPosition, 20.0 * delta)
	pass


func handleRecoilEffect() -> void:
	pivotRecoil.position.z = recoilCurve.sample_baked(recoilOffset) * 0.05 * playerState.recoilPosZStrength
	
	pivotRecoil.rotation.x = recoilCurve.sample_baked(recoilOffset) * 0.035 * playerState.recoilRotXStrength
	pivotRecoil.rotation.z = recoilCurve.sample_baked(recoilOffset) * -0.025 * recoilRotZSide * playerState.recoilRotZStrength
	
	recoilOffset = lerp(recoilOffset, 0.0, 10.0 * delta)
	pass

func addRecoil() -> void:
	recoilOffset = 1.0
	pass


func onPlayerShot(_recoilStrength: float) -> void:
	if(playerState.currentCameraMode == selfMode):
		addRecoil()
		recoilRotZSide = [1, -1].pick_random()
	pass


func onPickupWeapon(_newWeaponScene: Node3D) -> void:
	$PivotRot/PivotSway/PivotTilt/PivotPosture/PivotRecoil/PivotPosAim/WeaponsSocket.add_child(_newWeaponScene)
	pass
