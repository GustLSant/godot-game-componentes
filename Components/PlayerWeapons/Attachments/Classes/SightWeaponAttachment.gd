extends WeaponAttachment
class_name SightWeaponAttachment

@export var aimFOV: float = 45.0
@export var fpsBodyAimFOV: float = 45.0
@export var centerHeight: float = 0.25
@export var aimingSelfScaleMultiplier: float = 1.0


# Calculo da altura do centerHeight:
	# altura da base da mesh até o centro de foco dela


func _process(delta: float) -> void:
	var targetScale: float = float(Nodes.player.isAiming) * aimingSelfScaleMultiplier + float(not Nodes.player.isAiming) * 1.0
	self.scale.z = lerp(self.scale.z, targetScale, Nodes.player.AIM_SPEED * delta)
	pass


func applyStatsOnWeapon() -> void:
	attachedWeapon.armsAimPosition.y -= centerHeight
	attachedWeapon.aimFOV = aimFOV
	attachedWeapon.fpsBodyAimFOV = fpsBodyAimFOV
	pass
