extends Node
class_name T_WeaponAttachmentLoadout

var attachments: Dictionary[T_AttachmentType.ENUM, WeaponAttachment] = {
	T_AttachmentType.ENUM.SIGHT:    null,
	T_AttachmentType.ENUM.MAGAZINE: null,
	T_AttachmentType.ENUM.GRIP:     null,
	T_AttachmentType.ENUM.DEVICE_L: null,
	T_AttachmentType.ENUM.DEVICE_M: null,
	T_AttachmentType.ENUM.DEVICE_R: null,
	T_AttachmentType.ENUM.BARREL:   null,
}
