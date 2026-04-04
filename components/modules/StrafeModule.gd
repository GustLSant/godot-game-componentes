class_name StrafeModule
extends Node

const CAMERA_STRAFE_ANGLE: float = 7.5
const ARMS_STRAFE_ANGLE: float = 7.5
const STRAFE_X_POS_OFFSET: float = 0.4
const STRAFE_Y_POS_OFFSET: float = -0.1

const DEFAULT_SPEED_MULTIPLIER: float = 1.0
const STRAFING_SPEED_MULTIPLIER: float = 0.5

const LERP_FACTOR: float = 8.0

var isStrafing: bool :
	get: return currentDir != 0
var currentDir: int = 0
var currentCameraAngle: float = 0.0
var currentArmsAngle: float = 0.0
var currentPosOffset: Vector2 = Vector2.ZERO
var speedMultiplier: float = DEFAULT_SPEED_MULTIPLIER


func run(_strafeHoldMode: bool, _delta: float, canHandleInput: bool = true) -> void:
	if (canHandleInput): _handleInput(_strafeHoldMode)
	_handleStrafe(_delta)
	_handleSpeedMultiplier(_delta)
	pass


func _handleInput(_strafeHoldMode: bool) -> void:
	if (_strafeHoldMode):
		currentDir = int(Input.get_action_strength("StrafeRight") - Input.get_action_strength("StrafeLeft"))
	else:
		if (Input.is_action_just_pressed("StrafeRight")):
			var isNotStrafing: bool = currentDir != 1
			currentDir = int(isNotStrafing) * 1
		elif (Input.is_action_just_pressed("StrafeLeft")):
			var isNotStrafing: bool = currentDir != -1
			currentDir = int(isNotStrafing) * -1
	pass


func _handleStrafe(_delta: float) -> void:
	currentCameraAngle = lerp(
		currentCameraAngle,
		currentDir * -CAMERA_STRAFE_ANGLE,
		LERP_FACTOR * _delta
	)
	
	currentCameraAngle = lerp(
		currentCameraAngle,
		currentDir * -ARMS_STRAFE_ANGLE,
		LERP_FACTOR * _delta
	)
	
	currentPosOffset = lerp(
		currentPosOffset,
		Vector2(currentDir * STRAFE_X_POS_OFFSET, int(isStrafing) * STRAFE_Y_POS_OFFSET),
		LERP_FACTOR * _delta
	)
	pass


func _handleSpeedMultiplier(delta: float) -> void:
	speedMultiplier = lerp(
		speedMultiplier, 
		int(not isStrafing) * DEFAULT_SPEED_MULTIPLIER + int(isStrafing) * STRAFING_SPEED_MULTIPLIER,
		LERP_FACTOR * delta
	)
	pass
