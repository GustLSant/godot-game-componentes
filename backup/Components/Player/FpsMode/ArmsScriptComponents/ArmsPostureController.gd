extends Node
class_name ArmsPostureController

@export var pivot: Node3D
@onready var player: Player = Nodes.player

const MAX_HEIGHT_OFFSET: float = 0.075
var currentLeanHeightOffset: float = 0.0
var delta: float = 0.016


func _process(_delta: float) -> void:
	delta = _delta
	handleCrouchPosition()
	pass


func handleCrouchPosition() -> void:
	currentLeanHeightOffset = lerp(
		currentLeanHeightOffset, 
			-(player.currentPivotRot.rotation_degrees.x / player.currentCameraController.CAMERA_X_RANGE)
			* MAX_HEIGHT_OFFSET 
			* int(not player.isAiming),
		16.0 * delta
	)
	
	var targetPosY: float = (
		currentLeanHeightOffset +
		int(player.isCrouched) * player.CROUCH_HEIGHT +
		int(player.isCrouched and not player.isAiming) * 0.1
	)
	var targetPosZ: float = int(player.isCrouched and not player.isAiming) * 0.2
	
	pivot.position.y = lerp(pivot.position.y, targetPosY, player.CROUCH_SPEED * delta)
	pivot.position.z = lerp(pivot.position.z, targetPosZ, player.CROUCH_SPEED * delta)
	pass
