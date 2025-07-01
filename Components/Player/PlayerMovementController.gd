extends Node
class_name PlayerMovementController

@export var player: CharacterBody3D
@export var playerCameraManager: PlayerCameraManager

const BASE_MOVE_SPEED: float = 4.0
var vecInput: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	getInputs()
	move()
	pass


func getInputs() -> void:
	vecInput.x = Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft")
	vecInput.y = Input.get_action_strength("MoveBackwards") - Input.get_action_strength("MoveFoward")
	pass


func move() -> void:
	var vecMovement:Vector3 = Vector3(0.0, 0.0, 0.0)
	vecMovement = vecInput.x * playerCameraManager.currentPivotRot.transform.basis.x
	vecMovement += vecInput.y * playerCameraManager.currentPivotRot.transform.basis.z
	
	player.velocity = Vector3(vecMovement.x, player.velocity.y, vecMovement.z) * BASE_MOVE_SPEED
	player.move_and_slide()
	pass
