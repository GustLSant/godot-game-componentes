extends Node
class_name ArmsPostureController

@export var pivot: Node3D
@onready var playerState: PlayerState = Nodes.playerState

const ROT_HEIGHT_OFFSET: float = 0.1
var delta: float = 0.016


func _process(_delta: float) -> void:
	delta = _delta
	handleCrouchPosition()
	pass


func handleCrouchPosition() -> void:
	var rotationHeightOffset: float = -(playerState.currentPivotRot.rotation_degrees.x / playerState.currentCameraController.CAMERA_X_RANGE) * ROT_HEIGHT_OFFSET
	rotationHeightOffset = clamp(rotationHeightOffset, -ROT_HEIGHT_OFFSET, 0.05)
	
	var targetPosY: float = (
		rotationHeightOffset +
		int(playerState.isCrouched) * playerState.CROUCH_HEIGHT +
		int(playerState.isCrouched and not playerState.isAiming) * 0.15
	)
	var targetPosZ: float = int(playerState.isCrouched and not playerState.isAiming) * 0.25
	
	pivot.position.y = lerp(pivot.position.y, targetPosY, playerState.CROUCH_SPEED * delta)
	pivot.position.z = lerp(pivot.position.z, targetPosZ, playerState.CROUCH_SPEED * delta)
	pass
