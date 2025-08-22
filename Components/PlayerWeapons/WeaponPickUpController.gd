extends InteractiveObject
class_name WeaponPickupController

@export var weaponScenePath: String
@export var weaponSocket: Node3D
var attachmentPaths: Dictionary[T_AttachmentSlot.ENUM, String] = {
	T_AttachmentSlot.ENUM.SIGHT:    "",
	T_AttachmentSlot.ENUM.MAGAZINE: "",
	T_AttachmentSlot.ENUM.GRIP:     "",
	T_AttachmentSlot.ENUM.DEVICE_L: "",
	T_AttachmentSlot.ENUM.DEVICE_M: "",
	T_AttachmentSlot.ENUM.DEVICE_R: "",
	T_AttachmentSlot.ENUM.BARREL:   "",
}
var referenceWeapon: Node3D = null


func _ready() -> void:
	setupVisualAndAttachments()
	pass


func setupVisualAndAttachments() -> void:
	if(not referenceWeapon): return
	
	weaponScenePath = referenceWeapon.scene_file_path
	getAttachmentPaths(referenceWeapon)
	weaponSocket.call_deferred("add_child", Utils.getNodeVisualCopy(referenceWeapon.get_node("Mesh")))
	self.set_deferred("global_position", Nodes.player.global_position)
	
	self.rotation_degrees.y = randf_range(-180.0, 180.0)
	pass


func getAttachmentPaths(_weapon: PlayerWeapon) -> void:
	for attSlot: T_AttachmentSlot.ENUM in attachmentPaths:
		if(_weapon.attachments[attSlot]):
			attachmentPaths[attSlot] = _weapon.attachments[attSlot].scene_file_path
	pass


func action() -> void:
	var startAttachments: T_StartWeaponAttachmentLoadout = T_StartWeaponAttachmentLoadout.new()
	startAttachments.paths = attachmentPaths
	
	var w: PlayerWeapon = load(weaponScenePath).instantiate()
	w.startWeaponAttachmentsLoadout = startAttachments
	Nodes.player.emit_signal("PickupWeapon", w, true)
	
	self.queue_free()
	pass
