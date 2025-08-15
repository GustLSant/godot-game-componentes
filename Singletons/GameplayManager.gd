extends Node

var startInventory: T_StartInventory = T_StartInventory.new()

func _ready() -> void:
	var attLoadout_01: T_StartWeaponAttachmentLoadout = T_StartWeaponAttachmentLoadout.new()
	attLoadout_01.paths[T_AttachmentType.ENUM.SIGHT] = "res://Components/PlayerWeapons/Attachments/RedDotSight.tscn"
	#attLoadout_01.paths[T_AttachmentType.ENUM.SIGHT] = "res://Components/PlayerWeapons/Attachments/ScopeSight.tscn"
	attLoadout_01.paths[T_AttachmentType.ENUM.DEVICE_R] = "res://Components/PlayerWeapons/Attachments/RedLaserDevice.tscn"
	attLoadout_01.paths[T_AttachmentType.ENUM.DEVICE_L] = "res://Components/PlayerWeapons/Attachments/FlashlightDevice.tscn"
	
	var attLoadout_02: T_StartWeaponAttachmentLoadout = T_StartWeaponAttachmentLoadout.new()
	attLoadout_02.paths[T_AttachmentType.ENUM.SIGHT] = "res://Components/PlayerWeapons/Attachments/ScopeSight.tscn"
	#attLoadout_02.paths[T_AttachmentType.ENUM.SIGHT] = "res://Components/PlayerWeapons/Attachments/RedDotSight.tscn"
	#attLoadout_02.paths[T_AttachmentType.ENUM.DEVICE_M] = "res://Components/PlayerWeapons/Attachments/RedLaserDevice.tscn"
	
	startInventory.weapons = [
		"res://Components/PlayerWeapons/Weapon_01.tscn",
		"res://Components/PlayerWeapons/Weapon_01.tscn"
	]
	startInventory.weaponAttachments = [attLoadout_01, attLoadout_02]
	
	startInventory.reserveAmmo = [50, 0, 200, 0]
	pass
