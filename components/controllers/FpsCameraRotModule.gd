class_name FpsCameraRotModule
extends Node

const MAX_LOOK_ANGLE: float = 80.0
const MIN_LOOK_ANGLE: float = -80.0

const JOYSTICK_DEADZONE: float = 0.1
const JOYSTICK_SMOOTH_FACTOR: float = 16.0

var lastMouseMotion: Vector2 = Vector2.ZERO
var joystickSmoothed: Vector2 = Vector2.ZERO


func run(_pivotRot: Node3D, _xCamSensi: float, _yCamSensi: float, _xCamJoystickSensi: float, _yCamJoystickSensi: float, _delta: float) -> void:
	handleRotationByMouse(_pivotRot, _xCamSensi, _yCamSensi)
	handleRotationByJoystick(_pivotRot, _xCamJoystickSensi, _yCamJoystickSensi, _delta)
	pass


func _input(event):
	if event is InputEventMouseMotion:
		lastMouseMotion.x = event.relative.x
		lastMouseMotion.y = event.relative.y
	return


func handleRotationByMouse(_pivotRot: Node3D, _xCamSensi: float, _yCamSensi: float) -> void:
	_pivotRot.rotation_degrees.x -= lastMouseMotion.y * _yCamSensi
	_pivotRot.rotation_degrees.y -= lastMouseMotion.x * _xCamSensi
	lastMouseMotion = Vector2.ZERO
	
	_pivotRot.rotation_degrees.x = clamp(_pivotRot.rotation_degrees.x, MIN_LOOK_ANGLE, MAX_LOOK_ANGLE)
	pass







func handleRotationByJoystick(_pivotRot: Node3D, _xCamJoystickSensi: float, _yCamJoystickSensi: float, _delta: float) -> void:
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
