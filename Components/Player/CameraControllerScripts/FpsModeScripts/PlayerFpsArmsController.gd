extends PlayerModelController
class_name PlayerFpsArmsController

const ARMS_ROT_SPEED: float = 30.0
const ARMS_AIM_ROT_SPEED: float = 40.0

@export var pivotSway: Marker3D
@export var pivotTilt: Marker3D
@export var pivotPosture: Marker3D
@export var pivotAnim: Marker3D
@export var pivotRecoil: Marker3D
@export var pivotPosAim: Marker3D
@export var weaponSocket: Node3D
@export var animP: AnimationPlayer

@export var posRecoilCurve: Curve
@export var rotRecoilCurve: Curve
var tweenRecoil: Tween
var recoilCurveOffset: float = 0.0
var recoilRotZSide: float = 1.0

var nextWeaponScene: PlayerWeaponController = null
@export var changeWeaponRotXAnimValue: float = 0.0

var delta:float = 0.016


func _init() -> void:
	super._init()
	Nodes.playerState.connect("PickupWeapon", onPickupWeapon)
	Nodes.playerState.connect("TryChangeWeapon", onTryChangeWeapon)
	pass


func _ready() -> void:
	super._ready()
	pass


func _process(_delta: float) -> void:
	delta = _delta
	handleRotation()
	handleAimBehaviour()
	handleSwayEffect()
	handleTiltEffect()
	handlePostureEffect()
	handleReloadAnimEffect()
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
	const SWAY_WALKING_FREQUENCY:float = 0.0115
	const SWAY_IDLE_AMOUNT:float = 0.015
	const SWAY_WALKING_AMOUNT:float = 0.040
	
	var frequence:float = (
		SWAY_IDLE_FREQUENCY * int(not playerIsMoving) +
		SWAY_WALKING_FREQUENCY * int(playerIsMoving) +
		SWAY_WALKING_FREQUENCY * int(playerState.isSprinting)
	)
	var amount:float = (
		SWAY_IDLE_AMOUNT * int(not playerIsMoving) +
		SWAY_WALKING_AMOUNT * int(playerIsMoving) +
		SWAY_WALKING_AMOUNT * int(playerState.isSprinting)
	)
	
	var aimMultiplier: float = int(playerState.isAiming) * 0.5 + int(not playerState.isAiming) * 1.0
	var crouchMultiplier: float = int(playerState.isCrouched) * 0.75 + int(not playerState.isCrouched) * 1.0
	
	frequence *= aimMultiplier
	frequence *= crouchMultiplier
	amount *= aimMultiplier
	
	var xAmountMultiplier: float = int(not playerState.isSprinting) * 0.6 + int(playerState.isSprinting) * 2.0
	
	var targetSwayPosition: Vector3 = Vector3(
		sin(Time.get_ticks_msec()*frequence*0.5) * amount * xAmountMultiplier,
		sin(Time.get_ticks_msec()*frequence) * amount,
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
	
	targetRotationZ *= int(playerState.isAiming) * 0.25 + int(not playerState.isAiming) * 1.0
	targetRotationX *= int(playerState.isAiming) * 0.25 + int(not playerState.isAiming) * 1.0
	
	pivotTilt.rotation_degrees.z = lerp(pivotTilt.rotation_degrees.z, targetRotationZ, TILT_SPEED * delta)
	pivotTilt.rotation_degrees.x = lerp(pivotTilt.rotation_degrees.x, targetRotationX, TILT_SPEED * delta)
	pass


func handlePostureEffect() -> void:
	var isLongWeapon: bool = is_instance_valid(playerState.currentWeapon) and playerState.currentWeapon.ammoId > 0
	
	var targetXRotation:float = int(playerState.isSprinting) * -10.0 + int(playerState.isReloading) * -20.0
	var targetYRotation:float = int(playerState.isSprinting and isLongWeapon) * 45.0 + int(playerState.isSprinting and not isLongWeapon) * 15.0
	var targetXPosition:float = int(playerState.isSprinting) * 0.1 * int(isLongWeapon)
	var targetYPosition: float = int(not playerState.isOnFloor) * 0.2 + int(not playerState.isOnFloor and playerState.isAiming) * -0.15 + int(playerState.isCrouched) * -0.75
	
	pivotPosture.rotation_degrees.x = lerp(pivotPosture.rotation_degrees.x, targetXRotation, 10.0 * delta)
	pivotPosture.rotation_degrees.y = lerp(pivotPosture.rotation_degrees.y, targetYRotation, 10.0 * delta)
	pivotPosture.position.x = lerp(pivotPosture.position.x, targetXPosition, 10.0 * delta)
	pivotPosture.position.y = lerp(pivotPosture.position.y, targetYPosition, 10.0 * delta)
	pass


func handleReloadAnimEffect() -> void:
	pivotAnim.rotation_degrees.x = changeWeaponRotXAnimValue
	pass


func handleRecoilEffect() -> void:
	var targetPosZ: float = posRecoilCurve.sample_baked(recoilCurveOffset) * 0.1                  * playerState.recoilPosZStrength
	var targetRotX: float = rotRecoilCurve.sample_baked(recoilCurveOffset) * 2.0                  * playerState.recoilRotXStrength
	var targetRotZ: float = rotRecoilCurve.sample_baked(recoilCurveOffset) * 1.0 * recoilRotZSide * playerState.recoilRotZStrength
	
	pivotRecoil.position.z =         Utils.betterLerpF(pivotRecoil.position.z,         targetPosZ, 45.0, delta)
	pivotRecoil.rotation_degrees.x = Utils.betterLerpF(pivotRecoil.rotation_degrees.x, targetRotX, 45.0, delta)
	pivotRecoil.rotation_degrees.z = Utils.betterLerpF(pivotRecoil.rotation_degrees.z, targetRotZ, 45.0, delta)
	pass

func addRecoil() -> void:
	if(tweenRecoil):
		tweenRecoil.kill()
		tweenRecoil = get_tree().create_tween()
	else:
		tweenRecoil = get_tree().create_tween()
	
	recoilRotZSide = [-1, 1].pick_random()
	recoilCurveOffset = 1.0
	var tweenDuration: float = 0.4 / playerState.recoverFactor
	tweenRecoil.set_trans(Tween.TRANS_CUBIC)
	tweenRecoil.set_ease(Tween.EASE_OUT)
	tweenRecoil.tween_property(self, "recoilCurveOffset", 0.0, tweenDuration)
	pass


func onPlayerShot(_recoilStrength: float) -> void:
	if(playerState.currentCameraMode == selfMode):
		addRecoil()
	pass


func onPickupWeapon(_newWeaponScene: Node3D, _spawnOnPlayerModel: bool) -> void:
	if(_spawnOnPlayerModel):
		weaponSocket.call_deferred("add_child", _newWeaponScene)
	pass


func onTryChangeWeapon(_newWeaponScene: PlayerWeaponController) -> void:
	if(animP.is_playing()): return
	else:
		nextWeaponScene = _newWeaponScene
		animP.play("ChangeWeapon")
	pass


func onMiddleOfChangeWeaponAnimation() -> void:
	playerState.emit_signal("ChangeWeapon", nextWeaponScene)
	pass
