extends Node
class_name ArmsSwayController

@export var pivot: Node3D
@onready var playerState: PlayerState = Nodes.playerState

var delta: float = 0.016


func _process(_delta: float) -> void:
	delta = _delta
	handleSwayEffect()
	pass


func handleSwayEffect() -> void:
	var playerIsMoving: bool = Nodes.player.velocity.x != 0.0 or Nodes.player.velocity.z != 0.0
	const SWAY_IDLE_FREQUENCY:float = 0.0025
	const SWAY_WALKING_FREQUENCY:float = 0.0115
	const SWAY_IDLE_AMOUNT:float = 0.015
	const SWAY_WALKING_AMOUNT:float = 0.05 # 0.040
	
	var frequence:float = int(playerIsMoving) * SWAY_WALKING_FREQUENCY + int(not playerIsMoving) * SWAY_IDLE_FREQUENCY
	var amount:float =    int(playerIsMoving) * SWAY_WALKING_AMOUNT    + int(not playerIsMoving) * SWAY_IDLE_AMOUNT
	
	var aimMultiplier: float    = int(playerState.isAiming)    * playerState.AIM_MULTIPLIER_FACTOR    + int(not playerState.isAiming)    * 1.0
	var crouchMultiplier: float = int(playerState.isCrouched)  * playerState.CROUCH_MULTIPLIER_FACTOR + int(not playerState.isCrouched)  * 1.0
	var sprintMultiplier: float = int(playerState.isSprinting) * playerState.SPRINT_MULTIPLIER_FACTOR + int(not playerState.isSprinting) * 1.0
	
	frequence *= aimMultiplier
	frequence *= crouchMultiplier
	frequence *= sprintMultiplier
	amount *= aimMultiplier
	amount *= sprintMultiplier
	
	var xAmountMultiplier: float = 1.0 #int(not playerState.isSprinting) * 0.6 + int(playerState.isSprinting) * 2.0
	var yAmountMultiplier: float = 2.0
	
	var targetSwayPosition: Vector3 = Vector3(
		sin(Time.get_ticks_msec()*frequence*0.5) * amount * xAmountMultiplier,
		sin(Time.get_ticks_msec()*frequence) * amount * yAmountMultiplier,
		0.0
	)
	
	# cancelamento do efeito quando estiver no ar
	var finalPosition = int(playerState.isOnFloor) * targetSwayPosition + int(not playerState.isOnFloor) * pivot.position
	
	pivot.position = lerp(pivot.position, finalPosition, 10 * delta)
	pass
