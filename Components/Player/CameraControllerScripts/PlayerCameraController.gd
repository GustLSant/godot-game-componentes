extends Node
class_name PlayerCameraController

@export var playerState: PlayerState

@export_category("Internal Variables")
@export var selfMode: PlayerState.CAMERA_MODE = PlayerState.CAMERA_MODE.FPS
const CAMERA_X_RANGE = 75.0
@export var pivotRot:Marker3D
@export var camera: Camera3D

@export var pivotShake:Marker3D
const MAX_SHAKE_STRENGTH:float = 5.0
var currentShakeStrength:float = 0.0
var shakeNoise:FastNoiseLite = FastNoiseLite.new()
var shakePosOffset:Vector3 = Vector3.ZERO

var recoilDirection: Vector2 = Vector2.ZERO
var currentRecoilStrength: float = 0.0

var delta: float = 0.016


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	shakeNoise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	shakeNoise.frequency = 4.0
	
	setActive(selfMode == playerState.currentCameraMode)
	playerState.connect("CameraModeChanged", onCameraModeChanged)
	playerState.connect("PlayerShot", onPlayerShot)
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
	#currentShakeStrength = lerp(currentShakeStrength, 0.0, 14 * delta)
	currentShakeStrength -= 5.0 * delta
	currentShakeStrength = max(currentShakeStrength, 0.0)
	
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
	var defaultFOV:float = 75.0
	var targetFOV:float = int(playerState.isAiming) * (defaultFOV - 30.0) + int(not playerState.isAiming) * defaultFOV
	camera.fov = lerp(camera.fov, targetFOV, 10.0*delta)
	pass


func onCameraModeChanged() -> void:
	setActive(selfMode == playerState.currentCameraMode)
	pass

func setActive(_value) -> void:
	self.set_process(_value)
	self.set_physics_process(_value)
	self.set_process_input(_value)
	camera.current = _value
	
	if(_value):
		if(playerState.currentPivotRot): pivotRot.rotation = playerState.currentPivotRot.rotation # precisa da verificao para o primeiro setActive (do ready)
		playerState.currentPivotRot = pivotRot
		pass
	
	onActiveUpdate(_value)
	pass

func onActiveUpdate(_value) -> void:
	pass # evento para ser sobrescrito


func handleRecoilEffect() -> void:
	pivotRot.rotation_degrees.y += currentRecoilStrength * recoilDirection.x
	pivotRot.rotation_degrees.x += currentRecoilStrength * recoilDirection.y
	
	pivotRot.rotation_degrees.x = clamp(pivotRot.rotation_degrees.x, -CAMERA_X_RANGE, CAMERA_X_RANGE)
	
	currentRecoilStrength = lerp(currentRecoilStrength, 0.0, 10 * delta)
	pass


func addRecoil(_strength: float) -> void:
	recoilDirection = Vector2(randf_range(-0.5, 0.5), randf_range(0.5, 1.5))
	currentRecoilStrength += _strength
	currentRecoilStrength = clamp(currentRecoilStrength, 0.0, 10.0)
	pass


func onPlayerShot(_recoilStrength: float) -> void:
	if(playerState.currentCameraMode == selfMode):
		#addShake(_recoilStrength)
		addRecoil(_recoilStrength)
	pass
