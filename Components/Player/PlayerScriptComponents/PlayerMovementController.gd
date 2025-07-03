extends Node
class_name PlayerMovementController

@export var player: CharacterBody3D
@export var playerCameraManager: PlayerCameraManager
@export var playerCombatController: PlayerCombatController

const BASE_MOVE_SPEED: float = 4.0
var vecInput: Vector2 = Vector2.ZERO

const SPRINT_SPEED_MULTIPLIER:float = 3.0
var isSprinting: bool = false
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
	vecInput.x = Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft")
	vecInput.y = Input.get_action_strength("MoveBackwards") - Input.get_action_strength("MoveFoward")
	pass


func getSprintInput() -> void:
	var holdMode: bool = true
	
	if(holdMode):
		isSprinting = Input.is_action_pressed("Sprint")
	else:
		if(Input.is_action_just_pressed("Sprint")): isSprinting = !isSprinting
	pass


func handleSprint() -> void:
	isSprinting = isSprinting and vecInput != Vector2.ZERO
	if(playerCameraManager.currentCameraMode == playerCameraManager.CAMERA_MODE.FPS):
		isSprinting = isSprinting and vecInput.y < 0.0 # moving fowards
	isSprinting = isSprinting and (not playerCombatController.isAiming)
	#crouch
	
	currentSprintMultiplier = lerp(
		currentSprintMultiplier,
		int(isSprinting) * SPRINT_SPEED_MULTIPLIER + int(not isSprinting) * 1.0,
		10 * pDelta
		)
	pass


func move() -> void:
	var forward: Vector3 = playerCameraManager.currentPivotRot.transform.basis.z
	var right: Vector3 = playerCameraManager.currentPivotRot.transform.basis.x
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()
	
	var vecMovement: Vector3 = (vecInput.x * right + vecInput.y * forward).normalized()
	
	player.velocity = (
		Vector3(vecMovement.x, 0.0, vecMovement.z) * BASE_MOVE_SPEED * currentSprintMultiplier
		+
		Vector3.UP * player.velocity.y
		)
	player.move_and_slide()
	pass
