extends Node
class_name WeaponAttachment

var type: T_AttachmentType.ENUM = T_AttachmentType.ENUM.SIGHT
var attachedWeapon: PlayerWeapon = null


func _init() -> void:
	Nodes.player.connect("ChangeWeapon", onChangeWeapon)


func _ready() -> void:
	checkCanActiveProcess()
	pass


func checkCanActiveProcess() -> void:
	var isInTheCurrentWeapon: bool = (Nodes.player.currentWeapon.get_instance_id() == self.attachedWeapon.get_instance_id())
	set_process(isInTheCurrentWeapon)
	pass


func onChangeWeapon(_newWeapon: PlayerWeapon) -> void:
	checkCanActiveProcess()
	pass
