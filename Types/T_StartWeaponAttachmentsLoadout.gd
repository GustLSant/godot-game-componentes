extends Node
class_name T_StartWeaponAttachmentsLoadout

var paths: Dictionary[T_AttachmentType.ENUM, String] = {
	T_AttachmentType.ENUM.SIGHT:    "",
	T_AttachmentType.ENUM.MAGAZINE: "",
	T_AttachmentType.ENUM.GRIP:     "",
	T_AttachmentType.ENUM.DEVICE_L: "",
	T_AttachmentType.ENUM.DEVICE_M: "",
	T_AttachmentType.ENUM.DEVICE_R: "",
	T_AttachmentType.ENUM.BARREL:   "",
}
