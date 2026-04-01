class_name StrafeController
extends Node

class State:
	var currentDir: float = 0.0
	var currentCameraAngle: float = 0.0
	var currentArmsAngle: float = 0.0
	var currentPosOffset: Vector2 = Vector2.ZERO

const BASE_CAMERA_ANGLE: float = 7.5
const BASE_ARMS_ANGLE: float = 7.5
const BASE_X_POS_OFFSET: float = 0.4
const BASE_Y_POS_OFFSET: float = -0.1

const LERP_FACTOR: float = 8.0

var state: State = State.new()


func run(_strafeHoldMode: bool, _delta: float) -> void:
	handleInput(_strafeHoldMode)
	handleStrafe(_delta)
	pass


func handleInput(_strafeHoldMode: bool) -> void:
	if (_strafeHoldMode):
		state.currentDir = Input.get_action_strength("StrafeRight") - Input.get_action_strength("StrafeLeft")
	else:
		if (Input.is_action_just_pressed("StrafeRight")):
			var isNotStrafing: bool = state.currentDir != 1
			state.currentDir = int(isNotStrafing) * 1
		elif (Input.is_action_just_pressed("StrafeLeft")):
			var isNotStrafing: bool = state.currentDir != -1
			state.currentDir = int(isNotStrafing) * -1
	pass


func handleStrafe(_delta: float) -> void:
	state.currentCameraAngle = lerp(
		state.currentCameraAngle,
		state.currentDir * -BASE_CAMERA_ANGLE,
		LERP_FACTOR * _delta
	)
	
	state.currentCameraAngle = lerp(
		state.currentCameraAngle,
		state.currentDir * -BASE_ARMS_ANGLE,
		LERP_FACTOR * _delta
	)
	
	var isStrafing: bool = state.currentDir != 0
	state.currentPosOffset = lerp(
		state.currentPosOffset,
		Vector2(state.currentDir * BASE_X_POS_OFFSET, int(isStrafing) * BASE_Y_POS_OFFSET),
		LERP_FACTOR * _delta
	)
	pass
