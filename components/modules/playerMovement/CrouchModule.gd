class_name CrouchModule
extends Node

signal CrouchChanged(_newState: bool)

const BASE_SPEED_MUTLIPLIER: float = 1.0
const CROUCH_SPEED_MULTIPLIER: float = 0.5

const BASE_HEIGHT_OFFSET: float = 0.0
const CROUCH_HEIGHT_OFFSET: float = -0.4

const LERP_FACTOR: float = 12.0

var isCrouched: bool = false
var speedMultiplier: float = 1.0
var heightOffset: float = 0.0



func run(crouchHoldMode: bool, isHeadClear: bool, delta: float, canHandleInput: bool = true) -> void:
	_handleInput(crouchHoldMode, isHeadClear, canHandleInput)
	_handleCrouch(delta)
	pass


func _handleInput(crouchHoldMode: bool, isHeadClear: bool, canHandleInput: bool) -> void:
	if (not canHandleInput or (isCrouched and not isHeadClear)): return
	
	var oldCrouchState: bool = isCrouched
	
	if (crouchHoldMode):
		isCrouched = Input.is_action_pressed("Crouch")
	else:
		if (Input.is_action_just_pressed("Crouch")): isCrouched = !isCrouched
	
	if (isCrouched != oldCrouchState): emit_signal("CrouchChanged", isCrouched)
	pass


func _handleCrouch(delta: float) -> void:
	speedMultiplier = lerp(
		speedMultiplier,
		int(isCrouched) * CROUCH_SPEED_MULTIPLIER + int(not isCrouched) * BASE_SPEED_MUTLIPLIER,
		LERP_FACTOR * delta
	)
	
	heightOffset = lerp(
		heightOffset,
		int(isCrouched) * CROUCH_HEIGHT_OFFSET + int(not isCrouched) * BASE_HEIGHT_OFFSET,
		LERP_FACTOR * delta
	)
	pass


func changeCrouch(newValue: bool) -> void:
	isCrouched = newValue
	pass
