extends InteractiveObject
class_name PickUpWeapon

@export var weaponScenePath: String
@export var weaponSocket: Node3D
var attachments: Dictionary[T_AttachmentSlot.ENUM, WeaponAttachment] = {
	T_AttachmentSlot.ENUM.SIGHT:    null,
	T_AttachmentSlot.ENUM.MAGAZINE: null,
	T_AttachmentSlot.ENUM.GRIP:     null,
	T_AttachmentSlot.ENUM.DEVICE_L: null,
	T_AttachmentSlot.ENUM.DEVICE_M: null,
	T_AttachmentSlot.ENUM.DEVICE_R: null,
	T_AttachmentSlot.ENUM.BARREL:   null,
}


func action() -> void:
	var w: PlayerWeapon = load(weaponScenePath).instantiate()
	Nodes.player.emit_signal("PickupWeapon", w, true)
	self.queue_free()
	pass
