class_name GravityModule
extends Node

const GRAVITY_STRENGTH: float = 15.0

var motion: float = 0.0


func run(isOnFloor: bool, delta: float) -> void:
	if (not isOnFloor): motion -= GRAVITY_STRENGTH * delta
	else: motion = 0.0
	pass
