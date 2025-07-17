extends Node
class_name PlayerJumpController

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
	PlayerState.isOnFloor = Nodes.player.is_on_floor()
	
	if(PlayerState.isOnFloor):
		if(currentVerticalMovement <= -15.0): PlayerState.emit_signal("DamageTaken", Utils.getValueFraction(20.0, currentVerticalMovement, -20.0))
		currentVerticalMovement = 0.0
	else:
		currentVerticalMovement -= GRAVITY_ACCELERATION * pDelta
	pass


func handleJump() -> void:
	if(PlayerState.isOnFloor):
		if(Input.is_action_just_pressed("Jump")): currentVerticalMovement += JUMP_FORCE
	pass
