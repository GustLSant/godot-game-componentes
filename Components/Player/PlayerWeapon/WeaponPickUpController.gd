extends InteractiveObject

@export var weaponScenePath: String


func action() -> void:
	Nodes.playerState.emit_signal("PickupWeapon", load(weaponScenePath).instantiate(), true)
	self.queue_free()
	pass
