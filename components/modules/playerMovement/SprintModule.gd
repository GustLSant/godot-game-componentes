class_name SprintModule
extends Node

const BASE_SPEED_MULTIPLIER: float = 1.0
const SPRINT_SPEED_MUlTIPLIER: float = 2.0

const LERP_FACTOR: float = 12.0

signal SprintChanged(_newValue: bool)

var isSprinting: bool = false
var speedMultiplier: float = 1.0


func run(isPlayerOnFloor: bool, sprintHoldMode: bool, inputVecMovement: Vector2, delta: float, canHandleInput: bool = true) -> void:
	if (canHandleInput): _handleInput(isPlayerOnFloor, sprintHoldMode)
	_handleSprint(inputVecMovement, delta)
	pass


func _handleInput(isPlayerOnFloor: bool, sprintHoldMode: bool) -> void:
	if (not isPlayerOnFloor): return
	
	var oldSprintingState: bool = isSprinting
	
	if (sprintHoldMode):
		isSprinting = Input.is_action_pressed("Sprint")
	else:
		if(Input.is_action_just_pressed("Sprint")): isSprinting = !isSprinting
	
	if (isSprinting != oldSprintingState): emit_signal("SprintChanged", isSprinting)
	pass


func _handleSprint(inputVecMovement: Vector2, delta: float) -> void:
	var isMoving: bool = inputVecMovement != Vector2.ZERO
	var isMovingFowards: bool = inputVecMovement.y <= 0.0
	
	isSprinting = isSprinting and isMoving and isMovingFowards
	
	speedMultiplier = lerp(
		speedMultiplier,
		int(isSprinting) * SPRINT_SPEED_MUlTIPLIER + int(not isSprinting) * BASE_SPEED_MULTIPLIER,
		LERP_FACTOR * delta
	)
	pass


func changeSprinting(newValue: bool) -> void:
	isSprinting = newValue
	pass
