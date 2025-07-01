extends Node
class_name PlayerJumpController

@export var player: CharacterBody3D

const GRAVITY_ACCELERATION:float = 10.0
const JUMP_FORCE:float = 2.5
var currentVerticalMovement:float = 0.0

var pDelta: float = 0.016


func _physics_process(_delta: float) -> void:
	pDelta = _delta
	handleGravity()
	handleJump()
	player.velocity.y = currentVerticalMovement
	pass


func handleGravity() -> void:
	if(player.is_on_floor()):
		currentVerticalMovement = 0.0
	else:
		currentVerticalMovement -= GRAVITY_ACCELERATION * pDelta
	pass


func handleJump() -> void:
	if(player.is_on_floor()):
		if(Input.is_action_just_pressed("Jump")): currentVerticalMovement += JUMP_FORCE
	pass
