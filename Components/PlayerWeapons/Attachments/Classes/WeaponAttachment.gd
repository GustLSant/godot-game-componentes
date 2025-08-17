extends Node3D
class_name WeaponAttachment

var slot: T_AttachmentSlot.ENUM = T_AttachmentSlot.ENUM.SIGHT
@export var attachedWeapon: PlayerWeapon = null : set = setAttachedWeapon


func _init() -> void:
	Nodes.player.connect("WeaponChanged", onWeaponChanged)


func onWeaponChanged(_newWeapon: PlayerWeapon) -> void:
	checkCanActiveProcess()
	pass


func checkCanActiveProcess() -> void:
	var isInTheCurrentWeapon: bool = (Nodes.player.currentWeapon.get_instance_id() == self.attachedWeapon.get_instance_id())
	set_process(isInTheCurrentWeapon)
	pass


func setAttachedWeapon(_newAttachedWeapon: PlayerWeapon) -> void:
	attachedWeapon = _newAttachedWeapon
	applyStatsOnWeapon()
	pass


# funcao a ser sobrescrita em cada attachment
func applyStatsOnWeapon() -> void:
	pass
