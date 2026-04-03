class_name JumpController
extends Node

class State:
	var motion: float = 0.0

const JUMP_FORCE: float = 5.0

var state: State = State.new()


func run(_isPlayerOnFloor: bool, _delta: float) -> void:
	if (_isPlayerOnFloor):
		state.motion = 0.0
		if (Input.is_action_just_pressed("Jump")): state.motion = JUMP_FORCE
	pass
