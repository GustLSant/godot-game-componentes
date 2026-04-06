class_name LookLeadModule
extends Node

const ROT_X_AMOUNT_MULTIPLIER: float = 0.35
const ROT_Y_AMOUNT_MULTIPLIER: float = 0.35

const MAX_ROT_X: float = 10.0
const MAX_ROT_Y: float = 35.0

const LERP_FACTOR: float = 16.0

var _lastMouseMotion: Vector2 = Vector2.ZERO

var rotOffset: Vector3 = Vector3.ZERO


func run(amount: float, delta: float) -> void:
	rotOffset.x = lerp(
		rotOffset.x,
		_lastMouseMotion.y * ROT_X_AMOUNT_MULTIPLIER * amount * -1,
		LERP_FACTOR * delta
	)
	
	rotOffset.y = lerp(
		rotOffset.y,
		_lastMouseMotion.x * ROT_Y_AMOUNT_MULTIPLIER * amount * -1,
		LERP_FACTOR * delta
	)
	
	rotOffset.x = clamp(rotOffset.x, -MAX_ROT_X, MAX_ROT_X)
	rotOffset.y = clamp(rotOffset.y, -MAX_ROT_Y, MAX_ROT_Y)
	
	_lastMouseMotion = Vector2.ZERO
	pass


func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		_lastMouseMotion.x = event.relative.x
		_lastMouseMotion.y = event.relative.y
	return
