extends Node
class_name WeaponAttachment

@export var type: int = 0

@export_category("Passive Attachment")
@export var value: float = 1.0

@export_category("Active Attachment")
enum ACTIVE_KEY {ToggleDevice_L = 0, ToggleDevice_R = 1}
const KEYS = ["ToggleDevice_L", "ToggleDevice_R"]
@export var animP: AnimationPlayer
@export var key: ACTIVE_KEY = ACTIVE_KEY.ToggleDevice_L
var isActive: bool = true


func _ready() -> void:
	set_process(type == T_AttachmentType.DEVICE_L or type == T_AttachmentType.DEVICE_R)
	pass


func _process(delta: float) -> void:
	if(Input.is_action_just_pressed(KEYS[key])):
		if(isActive): animP.play("Deactive")
		else: animP.play("Active")
		isActive = not isActive
	pass
