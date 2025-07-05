extends Node
class_name PlayerJumpController

@export var playerState: PlayerState

const GRAVITY_ACCELERATION:float = 20.0
const JUMP_FORCE:float = 7.5
var currentVerticalMovement:float = 0.0

var pDelta: float = 0.016


func _physics_process(_delta: float) -> void:
	pDelta = _delta
	handleGravity()
	handleJump()
	playerState.player.velocity.y = currentVerticalMovement
	pass


func handleGravity() -> void:
	playerState.isOnFloor = playerState.player.is_on_floor()
	
	if(playerState.isOnFloor):
		currentVerticalMovement = 0.0
	else:
		currentVerticalMovement -= GRAVITY_ACCELERATION * pDelta
	pass


func handleJump() -> void:
	if(playerState.isOnFloor):
		if(Input.is_action_just_pressed("Jump")): currentVerticalMovement += JUMP_FORCE
	pass
