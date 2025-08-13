extends Node
class_name WeaponAttachment

@export var type: T_AttachmentType.ENUM = T_AttachmentType.ENUM.SIGHT

@export_category("Passive Attachment")
@export var value: float = 1.0

@export_category("Active Attachment")
@export var animP: AnimationPlayer
var isActive: bool = true
const dictTypeToInput: Dictionary = {
	T_AttachmentType.ENUM.DEVICE_L: "ToggleDevice_L",
	T_AttachmentType.ENUM.DEVICE_M: "ToggleDevice_M",
	T_AttachmentType.ENUM.DEVICE_R: "ToggleDevice_R",
}

func _ready() -> void:
	set_process(type == T_AttachmentType.ENUM.DEVICE_L or type == T_AttachmentType.ENUM.DEVICE_M or type == T_AttachmentType.ENUM.DEVICE_R)
	pass


func _process(delta: float) -> void:
	if(Input.is_action_just_pressed(dictTypeToInput[type])):
		if(isActive): animP.play("Deactive")
		else: animP.play("Active")
		isActive = not isActive
	pass
