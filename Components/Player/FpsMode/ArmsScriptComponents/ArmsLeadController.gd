extends Node
class_name ArmsLeadController

const STRENGTH_MULTIPLIER: float = 0.35
const MAX_EFFECT_X:float = 30.0
const MAX_EFFECT_Y:float = 15.0

@export var pivot: Node3D
var amount: Vector2 = Vector2.ZERO
var effectAmount: Vector2 = Vector2.ZERO


func _input(_event: InputEvent) -> void:
	if(_event is InputEventMouseMotion):
		amount = _event.relative
	pass


func _process(_delta: float) -> void:
	effectAmount = lerp(effectAmount, amount, 5.0 * _delta)
	
	clampEffect()
	pivot.rotation_degrees.x = -effectAmount.y * STRENGTH_MULTIPLIER
	pivot.rotation_degrees.y = -effectAmount.x * STRENGTH_MULTIPLIER
	
	amount = lerp(amount, Vector2.ZERO, 10.0 * _delta)
	pass


func clampEffect() -> void:
	effectAmount.x = clamp(effectAmount.x, -MAX_EFFECT_X, MAX_EFFECT_X)
	effectAmount.y = clamp(effectAmount.y, -MAX_EFFECT_Y, MAX_EFFECT_Y)
	
	#var isRotXExceeded: bool = abs(pivot.rotation_degrees.x) > MAX_ROT_X
	#var isRotYExceeded: bool = abs(pivot.rotation_degrees.y) > MAX_ROT_Y
	#pivot.rotation_degrees.x = int(isRotXExceeded) * MAX_ROT_X + int(not isRotXExceeded) * pivot.rotation_degrees.x
	#pivot.rotation_degrees.y = int(isRotYExceeded) * MAX_ROT_Y + int(not isRotYExceeded) * pivot.rotation_degrees.y
	pass
