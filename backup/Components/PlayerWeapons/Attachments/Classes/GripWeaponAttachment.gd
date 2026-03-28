extends WeaponAttachment
class_name GripWeaponAttachment

@export var recoilMultiplierFactor: float = 0.8


func applyStatsOnWeapon() -> void:
	attachedWeapon.cameraRecoilRotStrength *= recoilMultiplierFactor
	attachedWeapon.cameraRecoilShakeStrength *= recoilMultiplierFactor
	attachedWeapon.recoilPosZStrength *= recoilMultiplierFactor
	attachedWeapon.recoilPosYStrength *= recoilMultiplierFactor
	attachedWeapon.recoilRotXStrength *= recoilMultiplierFactor
	attachedWeapon.recoilRotZStrength *= recoilMultiplierFactor
	pass
