extends Node
class_name WeaponAttachment

var type: T_AttachmentType.ENUM = T_AttachmentType.ENUM.SIGHT
var attachedWeapon: PlayerWeapon = null : set = setAttachedWeapon


func _init() -> void:
	Nodes.player.connect("WeaponChanged", onWeaponChanged)


func checkCanActiveProcess() -> void:
	var isInTheCurrentWeapon: bool = (Nodes.player.currentWeapon.get_instance_id() == self.attachedWeapon.get_instance_id())
	set_process(isInTheCurrentWeapon)
	pass


func onWeaponChanged(_newWeapon: PlayerWeapon) -> void:
	checkCanActiveProcess()
	pass


func setAttachedWeapon(_newAttachedWeapon: PlayerWeapon) -> void:
	print('setter do attachment, name: ', self.name)
	attachedWeapon = _newAttachedWeapon
	applyStatsOnWeapon()
	pass


# funcao a ser sobrescrita em cada attachment
func applyStatsOnWeapon() -> void:
	pass
