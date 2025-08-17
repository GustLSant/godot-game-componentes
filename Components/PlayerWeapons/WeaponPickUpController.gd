extends InteractiveObject
class_name PickUpWeapon

@export var weaponScenePath: String
@export var weaponSocket: Node3D


func action() -> void:
	var w: PlayerWeapon = load(weaponScenePath).instantiate()
	Nodes.player.emit_signal("PickupWeapon", w, true)
	self.queue_free()
	pass
