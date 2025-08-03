extends Node
class_name ArmsPositionController

@export var pivot: Node3D
@onready var playerState: PlayerState = Nodes.playerState

var delta: float = 0.016


func _process(_delta: float) -> void:
	delta = _delta
	handlePosition()
	pass


func handlePosition() -> void:
	var targetXPos: float = int(playerState.isAiming) * playerState.armsAimPosition.x + int(not playerState.isAiming) * playerState.armsDefaultPosition.x
	var targetYPos: float = int(playerState.isAiming) * playerState.armsAimPosition.y + int(not playerState.isAiming) * playerState.armsDefaultPosition.y #+ crouchedPosOffset
	var targetZPos: float = int(playerState.isAiming) * playerState.armsAimPosition.z + int(not playerState.isAiming) * playerState.armsDefaultPosition.z
	
	pivot.position.x = lerp(pivot.position.x, targetXPos, 10.0 * delta)
	pivot.position.y = lerp(pivot.position.y, targetYPos, 10.0 * delta)
	pivot.position.z = lerp(pivot.position.z, targetZPos, 10.0 * delta)
	pass
