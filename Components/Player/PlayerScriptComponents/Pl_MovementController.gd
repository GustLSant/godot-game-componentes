extends Node
class_name Pl_MovementController

@onready var player: Player = Nodes.player

const BASE_MOVE_SPEED: float = 4.0
var currentSprintMultiplier: float = 1.0

var pDelta:float = 0.016


func _init() -> void:
	Nodes.player.connect("PlayerShot", onPlayerShot)
	pass


func _physics_process(_delta: float) -> void:
	pDelta = _delta
	getMoveInputs()
	handleSprintInput()
	handleSprint()
	handleMovement()
	pass


func getMoveInputs() -> void:
	player.inputVecMovement.x = Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft")
	player.inputVecMovement.y = Input.get_action_strength("MoveBackwards") - Input.get_action_strength("MoveFoward")
	pass


func handleSprintInput() -> void:
	if(not player.isOnFloor): return
	
	if(Settings.sprintHoldMode):
		player.isSprinting = Input.is_action_pressed("Sprint")
	else:
		if(Input.is_action_just_pressed("Sprint")): player.isSprinting = !player.isSprinting
	pass


func handleSprint() -> void:
	player.isSprinting = player.isSprinting and player.inputVecMovement != Vector2.ZERO
	if(player.currentCameraMode == player.CAMERA_MODE.FPS):
		player.isSprinting = player.isSprinting and player.inputVecMovement.y < 0.0 # moving fowards
	
	player.isSprinting = player.isSprinting and (not player.isAiming)
	player.isSprinting = player.isSprinting and (not player.isReloading)
	#crouch
	
	currentSprintMultiplier = lerp(
		currentSprintMultiplier,
		int(player.isSprinting) * player.SPRINT_MULTIPLIER_FACTOR + int(not player.isSprinting) * 1.0,
		10 * pDelta
		)
	pass


func handleMovement() -> void:
	var forward: Vector3 = player.currentPivotRot.transform.basis.z
	var right: Vector3 = player.currentPivotRot.transform.basis.x
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()
	
	var vecMovement: Vector3 = (player.inputVecMovement.x * right + player.inputVecMovement.y * forward).normalized()
	var aimingSpeedMultiplier: float = int(player.isAiming) * 0.35 + int(not player.isAiming) * 1.0
	var crouchSpeedMultiplier: float = int(player.isCrouched) * 0.75 + int(not player.isCrouched) * 1.0
	
	player.velocity = (
		Vector3(vecMovement.x, 0.0, vecMovement.z) * BASE_MOVE_SPEED * currentSprintMultiplier * aimingSpeedMultiplier * crouchSpeedMultiplier
		+
		Vector3.UP * player.velocity.y
		)
	player.move_and_slide()
	pass


func onPlayerShot(_recoilStrength: float) -> void:
	player.isSprinting = false
	pass
