extends Node
class_name PlayerWeaponSpawner

@export var weaponScenePath: String

func _ready() -> void:
	#Nodes.playerState.emit_signal("TryPickupWeapon", weaponScenePath)
	Nodes.playerState.emit_signal("PickupWeapon", weaponScenePath)
	pass
