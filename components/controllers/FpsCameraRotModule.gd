class_name FpsCameraRotModule
extends Node

const MAX_LOOK_ANGLE: float = 80.0
const MIN_LOOK_ANGLE: float = -80.0

const JOYSTICK_DEADZONE: float = 0.1
const JOYSTICK_SMOOTH_FACTOR: float = 16.0

var lastMouseMotion: Vector2 = Vector2.ZERO
var joystickSmoothed: Vector2 = Vector2.ZERO


func run(pivotRot: Node3D, xCamSensi: float, yCamSensi: float, xCamJoystickSensi: float, yCamJoystickSensi: float, delta: float) -> void:
	_handleRotationByMouse(pivotRot, xCamSensi, yCamSensi)
	_handleRotationByJoystick(pivotRot, xCamJoystickSensi, yCamJoystickSensi, delta)
	pass


func _input(event):
	if event is InputEventMouseMotion:
		lastMouseMotion.x = event.relative.x
		lastMouseMotion.y = event.relative.y
	return


func _handleRotationByMouse(pivotRot: Node3D, xCamSensi: float, yCamSensi: float) -> void:
	pivotRot.rotation_degrees.x -= lastMouseMotion.y * yCamSensi
	pivotRot.rotation_degrees.y -= lastMouseMotion.x * xCamSensi
	lastMouseMotion = Vector2.ZERO
	
	pivotRot.rotation_degrees.x = clamp(pivotRot.rotation_degrees.x, MIN_LOOK_ANGLE, MAX_LOOK_ANGLE)
	pass


func _handleRotationByJoystick(_pivotRot: Node3D, _xCamJoystickSensi: float, _yCamJoystickSensi: float, _delta: float) -> void:
	var inputVec: Vector2 = Vector2(
		Input.get_action_strength("LookLeft") - Input.get_action_strength("LookRight"),
		Input.get_action_strength("LookUp") - Input.get_action_strength("LookDown")
	)
	
	if (inputVec.length() < JOYSTICK_DEADZONE):
		inputVec = Vector2.ZERO
	else:
		inputVec = inputVec.normalized() * ((inputVec.length() - JOYSTICK_DEADZONE) / (1.0 - JOYSTICK_DEADZONE))
	
	joystickSmoothed = joystickSmoothed.lerp(inputVec, JOYSTICK_SMOOTH_FACTOR * _delta)
	
	_pivotRot.rotation_degrees.y += joystickSmoothed.x * _xCamJoystickSensi * _delta
	_pivotRot.rotation_degrees.x += joystickSmoothed.y * _yCamJoystickSensi * _delta
	
	_pivotRot.rotation_degrees.x = clamp(_pivotRot.rotation_degrees.x, MIN_LOOK_ANGLE, MAX_LOOK_ANGLE)
	return
