extends Node
class_name PlayerMovementController

@export var player: CharacterBody3D

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
	player.velocity = Vector3(vecInput.x, player.velocity.y, vecInput.y) * BASE_MOVE_SPEED
	player.move_and_slide()
	pass
