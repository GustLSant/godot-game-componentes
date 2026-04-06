class_name MovementTiltModule
extends Node

const LERP_FACTOR: float = 8.0

var rotOffset: Vector3 = Vector3.ZERO


func run(inputVec: Vector3, amount: float, delta: float) -> void:
	rotOffset.x = lerp(
		rotOffset.x,
		inputVec.z * amount * 0.5,
		LERP_FACTOR * delta
	)
	
	rotOffset.z = lerp(
		rotOffset.z,
		inputVec.x * amount * -1.0,
		LERP_FACTOR * delta
	)
	pass
