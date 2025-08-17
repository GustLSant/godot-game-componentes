extends Node
class_name T_StartWeaponAttachmentLoadout

var paths: Dictionary[T_AttachmentSlot.ENUM, String] = {
	T_AttachmentSlot.ENUM.SIGHT:    "",
	T_AttachmentSlot.ENUM.MAGAZINE: "",
	T_AttachmentSlot.ENUM.GRIP:     "",
	T_AttachmentSlot.ENUM.DEVICE_L: "",
	T_AttachmentSlot.ENUM.DEVICE_M: "",
	T_AttachmentSlot.ENUM.DEVICE_R: "",
	T_AttachmentSlot.ENUM.BARREL:   "",
}
