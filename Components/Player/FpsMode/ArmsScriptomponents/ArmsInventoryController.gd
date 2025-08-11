extends Node
class_name ArmsInventoryController

@export var weaponSocket: Node3D


func _init() -> void:
	Nodes.player.connect("PickupWeapon", onPickupWeapon)
	pass


func onPickupWeapon(_newWeapon: PlayerWeapon, _spawnOnPlayerModel: bool) -> void:
	if(_spawnOnPlayerModel):
		weaponSocket.call_deferred("add_child", _newWeapon)
	pass
