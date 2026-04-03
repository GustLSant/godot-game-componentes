class_name StrafeModule
extends Node

const BASE_CAMERA_ANGLE: float = 7.5
const BASE_ARMS_ANGLE: float = 7.5
const BASE_X_POS_OFFSET: float = 0.4
const BASE_Y_POS_OFFSET: float = -0.1

const LERP_FACTOR: float = 8.0

var currentDir: float = 0.0
var currentCameraAngle: float = 0.0
var currentArmsAngle: float = 0.0
var currentPosOffset: Vector2 = Vector2.ZERO


func run(_strafeHoldMode: bool, _delta: float, canHandleInput: bool = true) -> void:
	if (canHandleInput): _handleInput(_strafeHoldMode)
	_handleStrafe(_delta)
	pass


func _handleInput(_strafeHoldMode: bool) -> void:
	if (_strafeHoldMode):
		currentDir = Input.get_action_strength("StrafeRight") - Input.get_action_strength("StrafeLeft")
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
		currentDir * -BASE_CAMERA_ANGLE,
		LERP_FACTOR * _delta
	)
	
	currentCameraAngle = lerp(
		currentCameraAngle,
		currentDir * -BASE_ARMS_ANGLE,
		LERP_FACTOR * _delta
	)
	
	var isStrafing: bool = currentDir != 0
	currentPosOffset = lerp(
		currentPosOffset,
		Vector2(currentDir * BASE_X_POS_OFFSET, int(isStrafing) * BASE_Y_POS_OFFSET),
		LERP_FACTOR * _delta
	)
	pass
