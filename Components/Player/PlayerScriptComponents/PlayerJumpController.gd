extends Node
class_name PlayerJumpController

@onready var playerState: PlayerState = Nodes.playerState

const GRAVITY_ACCELERATION:float = 20.0
const JUMP_FORCE:float = 7.5
var currentVerticalMovement:float = 0.0

var pDelta: float = 0.016


func _physics_process(_delta: float) -> void:
	pDelta = _delta
	handleGravity()
	handleJump()
	Nodes.player.velocity.y = currentVerticalMovement
	pass


func handleGravity() -> void:
	playerState.isOnFloor = Nodes.player.is_on_floor()
	
	if(playerState.isOnFloor):
		if(currentVerticalMovement <= -15.0): playerState.emit_signal("DamageTaken", Utils.getValueFraction(20.0, currentVerticalMovement, -20.0))
		currentVerticalMovement = 0.0
	else:
		currentVerticalMovement -= GRAVITY_ACCELERATION * pDelta
	pass


func handleJump() -> void:
	if(playerState.isOnFloor):
		if(Input.is_action_just_pressed("Jump")): currentVerticalMovement += JUMP_FORCE
	pass
