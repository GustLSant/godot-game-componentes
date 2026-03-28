extends WeaponAttachment
class_name MagazineWeaponAttachment

@export var magazineSize: int = 30


func applyStatsOnWeapon() -> void:
	attachedWeapon.magazineSize = magazineSize
	pass
