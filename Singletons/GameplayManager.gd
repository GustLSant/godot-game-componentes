extends Node

var startInventory: Dictionary[String, Array] = {
	'weapons' = ["res://Components/Player/PlayerWeapon/Weapon_01.tscn"],
	'magazineAmmo' = [0, 0, 0, 0, 0], # municao de cada arma relacionada pelo idx dos arrays
	'reserveAmmo' = [50, 0, 200, 0],   # cada indice eh um tipo de municao
	'weaponAttachments' = [
		"res://Components/Player/PlayerWeapon/Attachments/RedLaserDevice.tscn"
		#WeaponAttachmentsLoadout.new(null, null, null, null, null, null),
		#WeaponAttachmentsLoadout.new(null, null, null, null, null, null),
		#WeaponAttachmentsLoadout.new(null, null, null, null, null, null),
		#WeaponAttachmentsLoadout.new(null, null, null, null, null, null),
	],
	'keyItems' = [],
	'misc' = []
}
