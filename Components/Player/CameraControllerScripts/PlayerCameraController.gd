extends Node
class_name PlayerCameraController

const CAMERA_X_RANGE = 75.0
@export var pivotRot:Marker3D
@export var camera: Camera3D

@export var pivotShake:Marker3D
const MAX_SHAKE_STRENGTH:float = 10.0
var currentShakeStrength:float = 0.0
var shakeNoise:FastNoiseLite = FastNoiseLite.new()
var shakePosOffset:Vector3 = Vector3.ZERO

var delta: float = 0.016


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	shakeNoise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	shakeNoise.frequency = 1.0
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
	pass


func handleShakeEffect() -> void:
	currentShakeStrength = lerp(currentShakeStrength, 0.0, 10*delta)
	
	shakePosOffset = Vector3(
		shakeNoise.get_noise_1d(currentShakeStrength) * currentShakeStrength,
		shakeNoise.get_noise_1d(currentShakeStrength*2.0) * currentShakeStrength,
		shakeNoise.get_noise_1d(currentShakeStrength*3.0) * currentShakeStrength
	)
	
	pivotShake.position = shakePosOffset
	pass


func addShake(_amount:float) -> void:
	currentShakeStrength += _amount
	currentShakeStrength = clamp(currentShakeStrength, 0.0, MAX_SHAKE_STRENGTH)
	pass


func setActive(_value, _otherCameraRotation: Vector3 = Vector3.ZERO) -> void:
	self.set_process(_value)
	self.set_physics_process(_value)
	self.set_process_input(_value)
	camera.current = _value
	
	if(_value):
		pivotRot.rotation = _otherCameraRotation
	
	onActiveUpdate(_value)
	pass


# evento para ser sobrescrito
func onActiveUpdate(_value) -> void:
	pass
