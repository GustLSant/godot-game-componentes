extends WeaponAttachment
class_name DeviceWeaponAttachment

@export var animP: AnimationPlayer
var isActive: bool = true
const dictTypeToInput: Dictionary = {
	T_AttachmentType.ENUM.DEVICE_L: "ToggleDevice_L",
	T_AttachmentType.ENUM.DEVICE_M: "ToggleDevice_M",
	T_AttachmentType.ENUM.DEVICE_R: "ToggleDevice_R",
}


func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed(dictTypeToInput[type])):
		if(isActive): animP.play("Deactive")
		else: animP.play("Active")
		isActive = not isActive
	pass
