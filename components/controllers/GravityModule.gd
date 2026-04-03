class_name GravityModule
extends Node

const GRAVITY_STRENGTH: float = 15.0

var motion: float = 0.0


func run(isPlayerOnFloor: bool, delta: float) -> void:
	if (not isPlayerOnFloor): motion -= GRAVITY_STRENGTH * delta
	else: motion = 0.0
	pass
