extends Node3D
class_name PlayerCameraController

@export_category("Internal Variables")
@export var selfMode: PlayerState.CAMERA_MODE = PlayerState.CAMERA_MODE.FPS
const CAMERA_X_RANGE = 75.0
@export var pivotRot:Marker3D
@export var camera: Camera3D

#region Shake
@export var pivotShake:Marker3D
const MAX_SHAKE_STRENGTH:float = 5.0
var currentShakeStrength:float = 0.0
var shakeNoise:FastNoiseLite = FastNoiseLite.new()
var shakePosOffset:Vector3 = Vector3.ZERO
#endregion

#region Recoil
const MAX_RECOIL_STRENGTH: float = 7.5
var recoilDirection: Vector2 = Vector2.ZERO
var currentRecoilStrength: float = 0.0
#endregion

var delta: float = 0.016


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	shakeNoise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	shakeNoise.frequency = 4.0
	
	setActive(selfMode == PlayerState.currentCameraMode)
	PlayerState.connect("CameraModeChanged", onCameraModeChanged)
	PlayerState.connect("PlayerShot", onPlayerShot)
	PlayerState.connect("DamageTaken", onDamageTaken)
	pass


func _input(_event: InputEvent) -> void:
	if(_event is InputEventMouseMotion):
		pivotRot.rotation_degrees.y -= _event.relative.x * 0.3
		pivotRot.rotation_degrees.x -= _event.relative.y * 0.3
		pivotRot.rotation_degrees.x = clamp(pivotRot.rotation_degrees.x, -CAMERA_X_RANGE, CAMERA_X_RANGE)
	pass


func _process(_delta: float) -> void:
	delta = _delta
	handleShakeEffect()
	handleAimBehaviour()
	handleRecoilEffect()
	pass


func handleShakeEffect() -> void:
	currentShakeStrength = lerp(currentShakeStrength, 0.0, 14 * delta)
	
	shakePosOffset = Vector3(
		shakeNoise.get_noise_1d(Time.get_ticks_msec()) * currentShakeStrength,
		shakeNoise.get_noise_1d(Time.get_ticks_msec() + 200) * currentShakeStrength,
		shakeNoise.get_noise_1d(Time.get_ticks_msec() + 400) * currentShakeStrength
	)
	
	var lerpFactor: float = 14 * delta
	pivotShake.position = lerp(pivotShake.position, shakePosOffset, min(lerpFactor, 1.0))
	pass

func addShake(_amount:float) -> void:
	currentShakeStrength += _amount
	currentShakeStrength = clamp(currentShakeStrength, 0.0, MAX_SHAKE_STRENGTH)
	pass


func handleAimBehaviour() -> void:
	var targetFOV:float = int(PlayerState.isAiming) * PlayerState.aimFOV + int(not PlayerState.isAiming) * Settings.defaultFOV
	camera.fov = lerp(camera.fov, targetFOV, 10.0*delta)
	pass


func onCameraModeChanged() -> void:
	setActive(selfMode == PlayerState.currentCameraMode)
	pass

func setActive(_value) -> void:
	self.set_process(_value)
	self.set_physics_process(_value)
	self.set_process_input(_value)
	camera.current = _value
	
	if(_value):
		if(PlayerState.currentPivotRot): pivotRot.rotation = PlayerState.currentPivotRot.rotation # precisa da verificao para o primeiro setActive (do ready)
		PlayerState.currentCameraController = self
		PlayerState.currentPivotRot = pivotRot
		pass
	
	onActiveUpdate(_value)
	pass

func onActiveUpdate(_value) -> void:
	pass # evento para ser sobrescrito


func handleRecoilEffect() -> void:
	pivotRot.rotation_degrees.y += currentRecoilStrength * recoilDirection.x
	pivotRot.rotation_degrees.x += currentRecoilStrength * recoilDirection.y
	
	pivotRot.rotation_degrees.x = clamp(pivotRot.rotation_degrees.x, -CAMERA_X_RANGE, CAMERA_X_RANGE)
	
	currentRecoilStrength = lerp(currentRecoilStrength, 0.0, 10.0 * delta)
	pass

func addRecoil(_strength: float) -> void:
	recoilDirection = Vector2(randf_range(-0.15, 0.15), randf_range(0.15, 0.5))
	currentRecoilStrength += _strength
	currentRecoilStrength = clamp(currentRecoilStrength, 0.0, MAX_RECOIL_STRENGTH)
	pass


func onPlayerShot(_recoilStrength: float) -> void:
	if(PlayerState.currentCameraMode == selfMode):
		addRecoil(_recoilStrength)
	pass


func onDamageTaken(_damage: int) -> void:
	if(PlayerState.currentCameraMode == selfMode):
		var shakeStrength: float = Utils.getValueFraction(MAX_SHAKE_STRENGTH, _damage, 50)
		addShake(shakeStrength)
	pass
