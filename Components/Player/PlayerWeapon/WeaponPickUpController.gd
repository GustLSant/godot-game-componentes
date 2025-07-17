extends InteractiveObject

@export var weaponScenePath: String


func action() -> void:
	PlayerState.emit_signal("TryPickupWeapon", weaponScenePath)
	pass
