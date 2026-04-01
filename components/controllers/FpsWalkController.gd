class_name FpsWalkController
extends Node

class State:
	var inputVec: Vector2 = Vector2.ZERO
	var walkVec: Vector3 = Vector3.ZERO
	var walkSpeed: float = BASE_MOVE_SPEED

const BASE_MOVE_SPEED: float = 4.0
var state: State = State.new()


func run(_pivotRotTransform: Transform3D) -> void:
	getMoveInputs()
	handleMovement(_pivotRotTransform)
	pass


func getMoveInputs() -> void:
	state.inputVec.x = Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft")
	state.inputVec.y = Input.get_action_strength("MoveBackward") - Input.get_action_strength("MoveForward")
	pass


func handleMovement(_pivotRotTransform: Transform3D) -> void:
	var forward: Vector3 = _pivotRotTransform.basis.z
	var right: Vector3 = _pivotRotTransform.basis.x
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()
	
	var vecMovement: Vector3 = (state.inputVec.x * right + state.inputVec.y * forward).normalized()
	
	state.walkVec = Vector3(vecMovement.x, 0.0, vecMovement.z) * state.walkSpeed
	pass
