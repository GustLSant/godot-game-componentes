extends Node
class_name Pl_JumpController

@onready var player: Player = Nodes.player

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
	player.isOnFloor = Nodes.player.is_on_floor()
	
	if(player.isOnFloor):
		if(currentVerticalMovement <= -15.0): player.emit_signal("DamageTaken", Utils.getValueFraction(20.0, currentVerticalMovement, -20.0))
		currentVerticalMovement = 0.0
	else:
		currentVerticalMovement -= GRAVITY_ACCELERATION * pDelta
	pass


func handleJump() -> void:
	if(player.isOnFloor):
		if(Input.is_action_just_pressed("Jump")): currentVerticalMovement += JUMP_FORCE
	pass
