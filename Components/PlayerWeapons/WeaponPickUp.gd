extends InteractiveObject
class_name WeaponPickup

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

var referenceWeapon: PlayerWeapon = null


func _ready() -> void:
	getAttachmentPaths()
	setupVisualAndAttachments()
	Nodes.player.connect("WeaponPickedUp", onWeaponPickedUp)
	pass


func setupVisualAndAttachments() -> void:
	if(not referenceWeapon): return
	
	weaponScenePath = referenceWeapon.scene_file_path
	weaponSocket.call_deferred("add_child", Utils.getNodeVisualCopy(referenceWeapon.get_node("Mesh")))
	self.set_deferred("global_position", Nodes.player.global_position)
	
	self.rotation_degrees.y = randf_range(-180.0, 180.0)
	pass


func getAttachmentPaths() -> void:
	if(not referenceWeapon): return
	
	for attSlot: T_AttachmentSlot.ENUM in attachmentPaths:
		if(referenceWeapon.attachments[attSlot]):
			attachmentPaths[attSlot] = referenceWeapon.attachments[attSlot].scene_file_path
	pass


func action() -> void:
	var startAttachments: T_StartWeaponAttachmentLoadout = T_StartWeaponAttachmentLoadout.new()
	startAttachments.paths = attachmentPaths
	
	var newWeapon: PlayerWeapon = load(weaponScenePath).instantiate()
	newWeapon.startWeaponAttachmentsLoadout = startAttachments
	
	var request: T_WeaponPickupRequest = T_WeaponPickupRequest.new()
	request.newWeapon = newWeapon
	request.weaponPickup = self
	
	Nodes.player.emit_signal("TryPickupWeapon", request)
	pass


func onWeaponPickedUp(_request: T_WeaponPickupRequest) -> void:
	if(_request.weaponPickup == self): self.queue_free()
	pass
