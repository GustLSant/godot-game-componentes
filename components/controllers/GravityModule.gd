class_name GravityModule
extends Node

const GRAVITY_STRENGTH: float = 15.0

var motion: float = 0.0


func run(_isPlayerOnFloor: bool, _delta: float) -> void:
	if (not _isPlayerOnFloor): motion -= GRAVITY_STRENGTH * _delta
	else: motion = 0.0
	pass
