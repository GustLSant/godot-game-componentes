extends Node
class_name PlayerMovementController

@export var player: CharacterBody3D

const BASE_MOVE_SPEED: float = 4.0

const SPRINT_SPEED_MULTIPLIER:float = 2.0
var currentSprintMultiplier: float = 1.0

var pDelta:float = 0.016


func _physics_process(_delta: float) -> void:
	pDelta = _delta
	getMoveInputs()
	getSprintInput()
	handleSprint()
	move()
	pass


func getMoveInputs() -> void:
	PlayerState.inputVecMovement.x = Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft")
	PlayerState.inputVecMovement.y = Input.get_action_strength("MoveBackwards") - Input.get_action_strength("MoveFoward")
	pass


func getSprintInput() -> void:
	if(not PlayerState.isOnFloor): return
	
	if(Settings.sprintHoldMode):
		PlayerState.isSprinting = Input.is_action_pressed("Sprint")
	else:
		if(Input.is_action_just_pressed("Sprint")): PlayerState.isSprinting = !PlayerState.isSprinting
	pass


func handleSprint() -> void:
	PlayerState.isSprinting = PlayerState.isSprinting and PlayerState.inputVecMovement != Vector2.ZERO
	if(PlayerState.currentCameraMode == PlayerState.CAMERA_MODE.FPS):
		PlayerState.isSprinting = PlayerState.isSprinting and PlayerState.inputVecMovement.y < 0.0 # moving fowards
	PlayerState.isSprinting = PlayerState.isSprinting and (not PlayerState.isAiming)
	#crouch
	
	currentSprintMultiplier = lerp(
		currentSprintMultiplier,
		int(PlayerState.isSprinting) * SPRINT_SPEED_MULTIPLIER + int(not PlayerState.isSprinting) * 1.0,
		10 * pDelta
		)
	pass


func move() -> void:
	var forward: Vector3 = PlayerState.currentPivotRot.transform.basis.z
	var right: Vector3 = PlayerState.currentPivotRot.transform.basis.x
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()
	
	var vecMovement: Vector3 = (PlayerState.inputVecMovement.x * right + PlayerState.inputVecMovement.y * forward).normalized()
	
	player.velocity = (
		Vector3(vecMovement.x, 0.0, vecMovement.z) * BASE_MOVE_SPEED * currentSprintMultiplier
		+
		Vector3.UP * player.velocity.y
		)
	player.move_and_slide()
	pass
