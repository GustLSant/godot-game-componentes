extends Node
class_name PlayerMovementController

@onready var playerState: PlayerState = Nodes.playerState
@onready var player: CharacterBody3D = Nodes.player

const BASE_MOVE_SPEED: float = 4.0
var currentSprintMultiplier: float = 1.0

var pDelta:float = 0.016


func _init() -> void:
	Nodes.playerState.connect("PlayerShot", onPlayerShot)
	pass


func _physics_process(_delta: float) -> void:
	pDelta = _delta
	getMoveInputs()
	handleSprintInput()
	handleSprint()
	handleMovement()
	pass


func getMoveInputs() -> void:
	playerState.inputVecMovement.x = Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft")
	playerState.inputVecMovement.y = Input.get_action_strength("MoveBackwards") - Input.get_action_strength("MoveFoward")
	pass


func handleSprintInput() -> void:
	if(not playerState.isOnFloor): return
	
	if(Settings.sprintHoldMode):
		playerState.isSprinting = Input.is_action_pressed("Sprint")
	else:
		if(Input.is_action_just_pressed("Sprint")): playerState.isSprinting = !playerState.isSprinting
	pass


func handleSprint() -> void:
	playerState.isSprinting = playerState.isSprinting and playerState.inputVecMovement != Vector2.ZERO
	if(playerState.currentCameraMode == playerState.CAMERA_MODE.FPS):
		playerState.isSprinting = playerState.isSprinting and playerState.inputVecMovement.y < 0.0 # moving fowards
	
	playerState.isSprinting = playerState.isSprinting and (not playerState.isAiming)
	playerState.isSprinting = playerState.isSprinting and (not playerState.isReloading)
	#crouch
	
	currentSprintMultiplier = lerp(
		currentSprintMultiplier,
		int(playerState.isSprinting) * playerState.SPRINT_MULTIPLIER_FACTOR + int(not playerState.isSprinting) * 1.0,
		10 * pDelta
		)
	pass


func handleMovement() -> void:
	var forward: Vector3 = playerState.currentPivotRot.transform.basis.z
	var right: Vector3 = playerState.currentPivotRot.transform.basis.x
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()
	
	var vecMovement: Vector3 = (playerState.inputVecMovement.x * right + playerState.inputVecMovement.y * forward).normalized()
	var aimingSpeedMultiplier: float = int(playerState.isAiming) * 0.35 + int(not playerState.isAiming) * 1.0
	var crouchSpeedMultiplier: float = int(playerState.isCrouched) * 0.75 + int(not playerState.isCrouched) * 1.0
	
	player.velocity = (
		Vector3(vecMovement.x, 0.0, vecMovement.z) * BASE_MOVE_SPEED * currentSprintMultiplier * aimingSpeedMultiplier * crouchSpeedMultiplier
		+
		Vector3.UP * player.velocity.y
		)
	player.move_and_slide()
	pass


func onPlayerShot(_recoilStrength: float) -> void:
	playerState.isSprinting = false
	pass
