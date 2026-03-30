class_name SprintController
extends Node

class State:
	var speedMultiplier: float = 1.0
	var isSprinting: bool = false

const SPRINT_MULTIPLIER_FACTOR: float = 2.0
var state: State = State.new()


func run(_isPlayerOnFloor: bool, _sprintHoldMode: bool, _inputVecMovement: Vector2, _delta: float) -> void:
	handleSprintInput(_isPlayerOnFloor, _sprintHoldMode)
	handleSprint(_inputVecMovement, _delta)
	pass


func handleSprintInput(_isPlayerOnFloor: bool, _sprintHoldMode: bool) -> void:
	if (not _isPlayerOnFloor): return
	
	if (_sprintHoldMode):
		state.isSprinting = Input.is_action_pressed("Sprint")
	else:
		if(Input.is_action_just_pressed("Sprint")): state.isSprinting = !state.isSprinting
	pass


func handleSprint(_inputVecMovement: Vector2, _delta: float) -> void:
	state.isSprinting = state.isSprinting and _inputVecMovement != Vector2.ZERO
	state.isSprinting = state.isSprinting and _inputVecMovement.y < 0.0 # moving fowards
	
	state.speedMultiplier = lerp(
		state.speedMultiplier,
		int(state.isSprinting) * SPRINT_MULTIPLIER_FACTOR + int(not state.isSprinting) * 1.0,
		10 * _delta
	)
	pass
