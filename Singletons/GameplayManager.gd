extends Node

var startInventory: T_StartInventory = T_StartInventory.new()

func _ready() -> void:
	startInventory.weapons = [
		"res://Components/PlayerWeapons/Weapon_01.tscn",
		"res://Components/PlayerWeapons/Weapon_02.tscn"
	]
	startInventory.weaponAttachments = [
		"res://Components/PlayerWeapons/Attachments/RedLaserDevice.tscn res://Components/PlayerWeapons/Attachments/FlashlightDevice.tscn",
		"res://Components/PlayerWeapons/Attachments/RedLaserDevice.tscn"
	]
	
	startInventory.reserveAmmo = [50, 0, 200, 0]
	pass
