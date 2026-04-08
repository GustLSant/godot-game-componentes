class_name FpsWalkModule
extends Node

const BASE_MOVE_SPEED: float = 4.0

var inputVec: Vector3 = Vector3.ZERO
var walkVec: Vector3 = Vector3.ZERO
var walkSpeed: float :
	get: return walkVec.length()


func run(pivotRotTransform: Transform3D, canHandleInput: bool = true) -> void:
	if (canHandleInput): _getMoveInputs()
	_handleMovement(pivotRotTransform)
	pass


func _getMoveInputs() -> void:
	inputVec.x = Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft")
	inputVec.z = Input.get_action_strength("MoveBackward") - Input.get_action_strength("MoveForward")
	pass


func _handleMovement(pivotRotTransform: Transform3D) -> void:
	var forward: Vector3 = pivotRotTransform.basis.z
	var right: Vector3 = pivotRotTransform.basis.x
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()
	
	var vecMovement: Vector3 = (inputVec.x * right + inputVec.z * forward).normalized()
	
	walkVec = Vector3(vecMovement.x, 0.0, vecMovement.z) * BASE_MOVE_SPEED
	pass
