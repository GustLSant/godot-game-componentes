class_name JumpController
extends Node

class State:
	var yMotion: float = 0.0

const JUMP_FORCE: float = 5.0
const GRAVITY_SPEED: float = 20.0

var state: State = State.new()


func run(_isPlayerOnFloor: bool, _delta: float) -> void:
	handleGravity(_isPlayerOnFloor, _delta)
	handleInput(_isPlayerOnFloor)
	pass


func handleGravity(_isPlayerOnFloor: bool, _delta: float) -> void:
	if (!_isPlayerOnFloor): state.yMotion -= GRAVITY_SPEED * _delta
	else: state.yMotion = 0.0
	pass


func handleInput(_isPlayerOnFloor: bool) -> void:
	if (_isPlayerOnFloor and Input.is_action_just_pressed("Jump")):
		state.yMotion += JUMP_FORCE
	pass
