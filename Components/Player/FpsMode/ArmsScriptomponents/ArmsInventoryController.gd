extends Node
class_name ArmsInventoryController

@export var weaponSocket: Node3D


func _init() -> void:
	Nodes.playerState.connect("PickupWeapon", onPickupWeapon)
	pass


func onPickupWeapon(_newWeaponData: T_WeaponData, _spawnOnPlayerModel: bool) -> void:
	if(_spawnOnPlayerModel):
		weaponSocket.call_deferred("add_child", _newWeaponData.instance)
	pass
