extends WeaponAttachment
class_name SightWeaponAttachment

@export var aimFOV: float = 45.0
@export var fpsBodyAimFOV: float = 45.0
@export var posAimOffsetByWeaponId: Dictionary[int, float] = {
	0: 0.0,
	1: -0.07,
	2: -0.16
}
@export var aimingSelfScaleMultiplier: float = 1.0


func _process(delta: float) -> void:
	var targetScale: float = float(Nodes.player.isAiming) * aimingSelfScaleMultiplier + float(not Nodes.player.isAiming) * 1.0
	self.scale.z = lerp(self.scale.z, targetScale, 10.0 * delta)
	pass
