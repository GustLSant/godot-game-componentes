extends InteractiveObject

@export var weaponScenePath: String


func action() -> void:
	Nodes.playerState.emit_signal("TryPickupWeapon", weaponScenePath)
	pass
