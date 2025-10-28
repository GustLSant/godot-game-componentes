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
	var targetZPos: float = int(player.isAiming) * player.armsAimPosition.z + int(not player.isAiming) * player.armsDefaultPosition.z
	var targetYPos: float = 0.0
	
	if(player.currentWeapon and player.currentWeapon.attachments[T_AttachmentSlot.ENUM.SIGHT]):
		targetYPos = (
			int(player.isAiming) * (player.armsAimPosition.y - player.sightAttachmentSlotHeight) +
			int(not player.isAiming) * player.armsDefaultPosition.y
		)
	else:
		targetYPos = (
			int(player.isAiming) * (player.armsAimPosition.y - player.ironSightHeight) +
			int(not player.isAiming) * player.armsDefaultPosition.y
		)
	
	pivot.position.x = lerp(pivot.position.x, targetXPos, player.AIM_SPEED * delta)
	pivot.position.y = lerp(pivot.position.y, targetYPos, player.AIM_SPEED * delta)
	pivot.position.z = lerp(pivot.position.z, targetZPos, player.AIM_SPEED * delta)
	pass
