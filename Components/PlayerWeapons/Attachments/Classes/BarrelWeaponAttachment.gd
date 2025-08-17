extends WeaponAttachment
class_name BarrelWeaponAttachment

@export var recoilMultiplierFactor: float = 0.8
@export var fireSpreadMultiplierFactor: float = 0.8
@export var noiseMultiplierFactor: float = 0.5
@export var allowMuzzleFlash: bool = true


func applyStatsOnWeapon() -> void:
	attachedWeapon.fireSpread *= fireSpreadMultiplierFactor
	
	attachedWeapon.cameraRecoilStrength *= recoilMultiplierFactor
	attachedWeapon.recoilShakeStrength *= recoilMultiplierFactor
	attachedWeapon.recoilPosZStrength *= recoilMultiplierFactor
	attachedWeapon.recoilPosYStrength *= recoilMultiplierFactor
	attachedWeapon.recoilRotXStrength *= recoilMultiplierFactor
	attachedWeapon.recoilRotZStrength *= recoilMultiplierFactor
	pass
