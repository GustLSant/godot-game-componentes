class_name FpsCameraRotModule
extends Node

const MAX_LOOK_ANGLE: float = 80.0
const MIN_LOOK_ANGLE: float = -80.0

const JOYSTICK_DEADZONE: float = 0.1
const JOYSTICK_SMOOTH_FACTOR: float = 16.0

var _lastMouseMotion: Vector2 = Vector2.ZERO
var _joystickSmoothed: Vector2 = Vector2.ZERO

var targetRotation: Vector3 = Vector3.ZERO


func run(currentRotaion: Vector3, xCamSensi: float, yCamSensi: float, xCamJoystickSensi: float, yCamJoystickSensi: float, delta: float) -> void:
	targetRotation = currentRotaion
	_handleRotationByMouse(xCamSensi, yCamSensi)
	_handleRotationByJoystick(xCamJoystickSensi, yCamJoystickSensi, delta)
	pass


func _input(event):
	if event is InputEventMouseMotion:
		_lastMouseMotion.x = event.relative.x
		_lastMouseMotion.y = event.relative.y
	return


func _handleRotationByMouse(xCamSensi: float, yCamSensi: float) -> void:
	targetRotation.x -= _lastMouseMotion.y * yCamSensi
	targetRotation.y -= _lastMouseMotion.x * xCamSensi
	_lastMouseMotion = Vector2.ZERO
	
	targetRotation.x = clamp(targetRotation.x, MIN_LOOK_ANGLE, MAX_LOOK_ANGLE)
	pass


func _handleRotationByJoystick(_xCamJoystickSensi: float, _yCamJoystickSensi: float, _delta: float) -> void:
	var inputVec: Vector2 = Vector2(
		Input.get_action_strength("LookLeft") - Input.get_action_strength("LookRight"),
		Input.get_action_strength("LookUp") - Input.get_action_strength("LookDown")
	)
	
	if (inputVec.length() < JOYSTICK_DEADZONE):
		inputVec = Vector2.ZERO
	else:
		inputVec = inputVec.normalized() * ((inputVec.length() - JOYSTICK_DEADZONE) / (1.0 - JOYSTICK_DEADZONE))
	
	_joystickSmoothed = _joystickSmoothed.lerp(inputVec, JOYSTICK_SMOOTH_FACTOR * _delta)
	
	targetRotation.y += _joystickSmoothed.x * _xCamJoystickSensi * _delta
	targetRotation.x += _joystickSmoothed.y * _yCamJoystickSensi * _delta
	
	targetRotation.x = clamp(targetRotation.x, MIN_LOOK_ANGLE, MAX_LOOK_ANGLE)
	return
