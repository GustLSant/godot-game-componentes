class_name SprintModule
extends Node

class State:
	var speedMultiplier: float = 1.0
	var isSprinting: bool = false

class Actions:
	var changeSprinting: Callable

signal SprintChanged(_newValue: bool)

const BASE_SPEED_MULTIPLIER: float = 1.0
const SPRINT_SPEED_MUlTIPLIER: float = 2.0

const LERP_FACTOR: float = 12.0

var state: State = State.new()
var actions: Actions = Actions.new()


func _ready() -> void:
	actions.changeSprinting = changeSprint
	pass


func run(_isPlayerOnFloor: bool, _sprintHoldMode: bool, _inputVecMovement: Vector2, _delta: float) -> void:
	handleInput(_isPlayerOnFloor, _sprintHoldMode)
	handleSprint(_inputVecMovement, _delta)
	pass


func handleInput(_isPlayerOnFloor: bool, _sprintHoldMode: bool) -> void:
	if (not _isPlayerOnFloor): return
	
	var oldSprintingState: bool = state.isSprinting
	
	if (_sprintHoldMode):
		state.isSprinting = Input.is_action_pressed("Sprint")
	else:
		if(Input.is_action_just_pressed("Sprint")): state.isSprinting = !state.isSprinting
	
	if (state.isSprinting != oldSprintingState): emit_signal("SprintChanged", state.isSprinting)
	pass


func handleSprint(_inputVecMovement: Vector2, _delta: float) -> void:
	state.isSprinting = state.isSprinting and _inputVecMovement != Vector2.ZERO
	state.isSprinting = state.isSprinting and _inputVecMovement.y <= 0.0 # moving fowards
	
	state.speedMultiplier = lerp(
		state.speedMultiplier,
		int(state.isSprinting) * SPRINT_SPEED_MUlTIPLIER + int(not state.isSprinting) * BASE_SPEED_MULTIPLIER,
		LERP_FACTOR * _delta
	)
	pass


func changeSprint(_newValue: bool) -> void:
	state.isSprinting = _newValue
	pass
