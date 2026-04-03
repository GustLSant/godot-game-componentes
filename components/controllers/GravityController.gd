class_name GravityController
extends Node

class State:
	var motion: float = 0.0

var state: State = State.new()

const GRAVITY_STRENGTH: float = 15.0

func run(_isPlayerOnFloor: bool, _delta: float) -> void:
	if (not _isPlayerOnFloor): state.motion -= GRAVITY_STRENGTH * _delta
	else: state.motion = 0.0
	pass
