class_name JumpModule
extends Node

const JUMP_FORCE: float = 5.0

var motion: float = 0.0


func run(isPlayerOnFloor: bool) -> void:
	if (isPlayerOnFloor):
		motion = 0.0
		if (Input.is_action_just_pressed("Jump")): motion = JUMP_FORCE
	pass
