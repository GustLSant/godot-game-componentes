class_name PlayerCamera
extends Node3D

@onready var player:TpsFpsPlayer = $".."
@onready var body:PlayerBody = $"../Body"
@export var pathCameraNode:NodePath
@onready var cameraNode:Camera3D = get_node(pathCameraNode)

# Camera Rotation
const CAMERA_SENSI:float = 0.3
const CAMERA_X_RANGE:float = 80.0
@export var pathPivotRot:NodePath
@onready var pivotRot:Marker3D = get_node(pathPivotRot)

#region Shake
@export var pathPivotShake:NodePath
@onready var pivotShake:Marker3D = get_node(pathPivotShake)
const MAX_SHAKE_STRENGTH:float = 10.0
var currentShakeStrength:float = 0.0
var shakeNoise:FastNoiseLite = FastNoiseLite.new()
var shakePosOffset:Vector3 = Vector3.ZERO

var delta:float = 0.01


func _ready()->void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	shakeNoise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	shakeNoise.frequency = 1.0
pass


func _input(_event:InputEvent)->void:
	if(_event is InputEventMouseMotion):
		pivotRot.rotation_degrees.y -= _event.relative.x * CAMERA_SENSI * (0.5*int(player.isAiming) + 1.0*int(not player.isAiming))
		pivotRot.rotation_degrees.x -= _event.relative.y * CAMERA_SENSI * (0.5*int(player.isAiming) + 1.0*int(not player.isAiming))
		pivotRot.rotation_degrees.x = clamp(pivotRot.rotation_degrees.x, -CAMERA_X_RANGE, CAMERA_X_RANGE)
	pass


func setActive(_active:bool, _previousCameraRotation:Vector3=Vector3.ZERO)->void:
	self.visible = _active
	self.set_process(_active)
	self.set_process_input(_active)
	self.set_physics_process(_active)
	cameraNode.current = _active
	
	if(_active):
		pivotRot.rotation = _previousCameraRotation
		pivotRot.rotation_degrees.x = clamp(pivotRot.rotation_degrees.x, -CAMERA_X_RANGE, CAMERA_X_RANGE)
		currentShakeStrength = 0.0
	pass


func handleShakeEffect()->void:
	currentShakeStrength = lerp(currentShakeStrength, 0.0, 10*delta)
	
	shakePosOffset = Vector3(
		shakeNoise.get_noise_1d(currentShakeStrength) * currentShakeStrength,
		shakeNoise.get_noise_1d(currentShakeStrength*2.0) * currentShakeStrength,
		shakeNoise.get_noise_1d(currentShakeStrength*3.0) * currentShakeStrength
	)
	
	pivotShake.position = shakePosOffset
	pass


func addCameraShake(_amount:float)->void:
	currentShakeStrength += _amount
	currentShakeStrength = clamp(currentShakeStrength, 0.0, MAX_SHAKE_STRENGTH)
	pass
