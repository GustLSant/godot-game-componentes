extends InteractiveObject
class_name WeaponPickupController

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


func setup(_weapon: PlayerWeapon) -> void:
	weaponSocket.call_deferred("add_child", Utils.getNodeVisualCopy(_weapon.get_node("Mesh")))
	self.set_deferred("global_position", Nodes.player.global_position)
	self.rotation_degrees.y = randf_range(-180.0, 180.0)
	pass


func action() -> void:
	var w: PlayerWeapon = load(weaponScenePath).instantiate()
	Nodes.player.emit_signal("PickupWeapon", w, true)
	self.queue_free()
	pass
