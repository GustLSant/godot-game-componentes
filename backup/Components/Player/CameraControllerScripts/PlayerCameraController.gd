extends Node3D
class_name PlayerCameraController

@onready var player: Player = Nodes.player

@export_category("Internal Variables")
const CAMERA_X_RANGE = 80.0
@export var selfMode: Player.CAMERA_MODE = Player.CAMERA_MODE.FPS
@export var camera: Camera3D
@export var pivotRot:Marker3D

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


func _init() -> void:
	Nodes.player.connect("CameraModeChanged", onCameraModeChanged)
	Nodes.player.connect("PlayerShot", onPlayerShot)
	Nodes.player.connect("DamageTaken", onDamageTaken)
	pass


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	shakeNoise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	shakeNoise.frequency = 4.0
	
	setActive(selfMode == player.currentCameraMode)
	pass


func _input(_event: InputEvent) -> void:
	if(_event is InputEventMouseMotion):
		pivotRot.rotation_degrees.y -= _event.relative.x * Settings.cameraSensitivity
		pivotRot.rotation_degrees.x -= _event.relative.y * Settings.cameraSensitivity
		pivotRot.rotation_degrees.x = clamp(pivotRot.rotation_degrees.x, -CAMERA_X_RANGE, CAMERA_X_RANGE)
	pass


func _process(_delta: float) -> void:
	delta = _delta
	handleShakeEffect()
	handleAimBehaviour()
	handleRecoilEffect()
	pass


func handleShakeEffect() -> void:
	var lerpFactor: float = min(24 * delta, 1.0)
	
	currentShakeStrength = lerp(currentShakeStrength, 0.0, lerpFactor)
	
	shakePosOffset = Vector3(
		shakeNoise.get_noise_1d(Time.get_ticks_msec()) * currentShakeStrength,
		shakeNoise.get_noise_1d(Time.get_ticks_msec() + 200) * currentShakeStrength,
		shakeNoise.get_noise_1d(Time.get_ticks_msec() + 400) * currentShakeStrength
	)
	
	pivotShake.position = lerp(pivotShake.position, shakePosOffset, lerpFactor)
	pass

func addShake(_amount:float) -> void:
	currentShakeStrength += _amount
	currentShakeStrength = clamp(currentShakeStrength, 0.0, MAX_SHAKE_STRENGTH)
	pass


func handleAimBehaviour() -> void:
	var targetFOV:float = int(player.isAiming) * player.aimFOV + int(not player.isAiming) * Settings.defaultFOV
	camera.fov = lerp(camera.fov, targetFOV, 10.0*delta)
	pass


func onCameraModeChanged() -> void:
	setActive(selfMode == player.currentCameraMode)
	pass

func setActive(_value) -> void:
	self.set_process(_value)
	self.set_physics_process(_value)
	self.set_process_input(_value)
	camera.current = _value
	
	if(_value):
		if(player.currentPivotRot): pivotRot.rotation = player.currentPivotRot.rotation # precisa da verificao para o primeiro setActive (do ready)
		player.currentCameraController = self
		player.currentPivotRot = pivotRot
		pass
	
	onActiveUpdate(_value)
	pass

func onActiveUpdate(_value) -> void:
	pass # evento para ser sobrescrito


func handleRecoilEffect() -> void:
	pivotRot.rotation_degrees.y += currentRecoilStrength * recoilDirection.x * delta
	pivotRot.rotation_degrees.x += currentRecoilStrength * recoilDirection.y * delta
	
	pivotRot.rotation_degrees.x = clamp(pivotRot.rotation_degrees.x, -CAMERA_X_RANGE, CAMERA_X_RANGE)
	
	currentRecoilStrength = lerp(currentRecoilStrength, 0.0, 10.0 * delta)
	pass

func addRecoil(_strength: float) -> void:
	var crouchStrengthMultiplier: float = float(player.isCrouched) * 0.5 + float(not player.isCrouched) * 1.0
	
	recoilDirection = Vector2(randf_range(-5, 5), randf_range(10.0, 20.0))
	currentRecoilStrength += _strength * crouchStrengthMultiplier
	currentRecoilStrength = clamp(currentRecoilStrength, 0.0, MAX_RECOIL_STRENGTH)
	pass


func onPlayerShot(_payload: T_PlayerShotPayload) -> void:
	if(player.currentCameraMode == selfMode):
		addRecoil(_payload.cameraRecoilRotStrength)
		addShake(_payload.cameraRecoilShakeStrength)
	pass


func onDamageTaken(_damage: int) -> void:
	if(player.currentCameraMode == selfMode):
		var shakeStrength: float = Utils.getValueFraction(MAX_SHAKE_STRENGTH, _damage, 50)
		addShake(shakeStrength)
	pass
