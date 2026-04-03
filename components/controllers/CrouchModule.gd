class_name CrouchModule
extends Node

class State:
	var isCrouched: bool = false
	var speedMultiplier: float = 1.0
	var heightOffset: float = 0.0

class Actions:
	var changeCrouch: Callable

signal CrouchChanged(_newState: bool)

const BASE_SPEED_MUTLIPLIER: float = 1.0
const CROUCH_SPEED_MULTIPLIER: float = 0.5

const BASE_HEIGHT_OFFSET: float = 0.0
const CROUCH_HEIGHT_OFFSET: float = -0.4

const LERP_FACTOR: float = 12.0

var state:State = State.new()
var actions:Actions = Actions.new()


func _ready() -> void:
	actions.changeCrouch = changeCrouch
	pass


func run(_crouchHoldMode: bool, _canStand: bool, _delta: float) -> void:
	handleInput(_crouchHoldMode, _canStand)
	handleCrouch(_delta)
	pass


func handleInput(_crouchHoldMode: bool, _canStand: bool) -> void:
	if (state.isCrouched and not _canStand): return
	
	var oldCrouchState: bool = state.isCrouched
	
	if (_crouchHoldMode):
		state.isCrouched = Input.is_action_pressed("Crouch")
	else:
		if (Input.is_action_just_pressed("Crouch")): state.isCrouched = !state.isCrouched
	
	if (state.isCrouched != oldCrouchState): emit_signal("CrouchChanged", state.isCrouched)
	pass


func handleCrouch(_delta: float) -> void:
	state.speedMultiplier = lerp(
		state.speedMultiplier,
		int(state.isCrouched) * CROUCH_SPEED_MULTIPLIER + int(not state.isCrouched) * BASE_SPEED_MUTLIPLIER,
		LERP_FACTOR * _delta
	)
	
	state.heightOffset = lerp(
		state.heightOffset,
		int(state.isCrouched) * CROUCH_HEIGHT_OFFSET + int(not state.isCrouched) * BASE_HEIGHT_OFFSET,
		LERP_FACTOR * _delta
	)
	pass


func changeCrouch(_newValue: bool) -> void:
	state.isCrouched = _newValue
	pass
