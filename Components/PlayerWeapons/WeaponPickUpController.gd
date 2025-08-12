extends InteractiveObject

@export var weaponScenePath: String


func action() -> void:
	var w: PlayerWeapon = load(weaponScenePath).instantiate()
	Nodes.player.emit_signal("PickupWeapon", w, true)
	self.queue_free()
	pass
