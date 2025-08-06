extends Node
class_name PlayerWeaponSpawner

@export var weaponScenePath: String = ""

func _ready() -> void:
	if(weaponScenePath != ""):
		Nodes.playerState.emit_signal("PickupWeapon", load(weaponScenePath).instantiate(), true)
	pass
