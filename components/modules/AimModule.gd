class_name AimModule
extends Node

const LERP_SPEED: float = 12.0

var isAiming: bool = false
var aimFactor: float = 0.0


func run(aimHoldMode: bool, delta: float, canHandleInput: bool = true) -> void:
	_handleInput(aimHoldMode, canHandleInput)
	_handleAimFactor(delta)
	pass


func _handleInput(aimHoldMode: bool, canHandleInput: bool = true) -> void:
	if (not canHandleInput): return
	
	if (aimHoldMode):
		isAiming = Input.is_action_pressed('Aim')
	else:
		if (Input.is_action_just_pressed('Aim')): isAiming = !isAiming
	pass


func _handleAimFactor(delta: float) -> void:
	aimFactor = lerp(
		aimFactor,
		float(isAiming),
		LERP_SPEED * delta
	)
	pass
