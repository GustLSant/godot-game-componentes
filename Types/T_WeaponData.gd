extends Node
class_name T_WeaponData

var instance: PlayerWeaponController = null
var magazineAmmo: int = 0
var attachments: T_WeaponAttachmentsData = T_WeaponAttachmentsData.new(null,null,null,null,null,null)

func _init(_instance: PlayerWeaponController) -> void:
	instance = _instance
	pass
