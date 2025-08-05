extends Node
class_name ArmsPostureController

@export var pivot: Node3D
@onready var playerState: PlayerState = Nodes.playerState

var delta: float = 0.016


func _process(_delta: float) -> void:
	delta = _delta
	handleCrouchPosition()
	pass


func handleCrouchPosition() -> void:
	var targetPosY: float = int(playerState.isCrouched) * playerState.CROUCH_HEIGHT + int(playerState.isCrouched and not playerState.isAiming) * 0.1
	var targetPosZ: float = int(playerState.isCrouched) * 0.2
	pivot.position.y = lerp(pivot.position.y, targetPosY, playerState.CROUCH_SPEED * delta)
	pivot.position.z = lerp(pivot.position.z, targetPosZ, playerState.CROUCH_SPEED * delta)
	pass
