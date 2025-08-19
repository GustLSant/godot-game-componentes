extends WeaponAttachment
class_name DeviceWeaponAttachment

@export var featureNode: Node3D
@export var animP: AnimationPlayer
var isActive: bool = true
const dictSlotToInput: Dictionary = {
	T_AttachmentSlot.ENUM.DEVICE_L: "ToggleDevice_L",
	T_AttachmentSlot.ENUM.DEVICE_M: "ToggleDevice_M",
	T_AttachmentSlot.ENUM.DEVICE_R: "ToggleDevice_R",
}


func _ready() -> void:
	featureNode.visible = true
	pass



func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed(dictSlotToInput[slot])):
		if(isActive): animP.play("Deactive")
		else: animP.play("Active")
		isActive = not isActive
	pass
