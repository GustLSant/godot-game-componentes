extends Node
class_name ArmsPositionController

@export var pivot: Node3D
@onready var player: Player = Nodes.player

var delta: float = 0.016


func _process(_delta: float) -> void:
	delta = _delta
	handlePosition()
	pass


func handlePosition() -> void:
	var targetXPos: float = int(player.isAiming) * player.armsAimPosition.x + int(not player.isAiming) * player.armsDefaultPosition.x
	var targetYPos: float = int(player.isAiming) * player.armsAimPosition.y + int(not player.isAiming) * player.armsDefaultPosition.y #+ crouchedPosOffset
	var targetZPos: float = int(player.isAiming) * player.armsAimPosition.z + int(not player.isAiming) * player.armsDefaultPosition.z
	
	pivot.position.x = lerp(pivot.position.x, targetXPos, 10.0 * delta)
	pivot.position.y = lerp(pivot.position.y, targetYPos, 10.0 * delta)
	pivot.position.z = lerp(pivot.position.z, targetZPos, 10.0 * delta)
	pass
