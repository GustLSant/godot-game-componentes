extends Node
class_name T_StartWeaponAttachment

var scenePath: String = ""
var type: int = 0


func _init(_s: String, _t:int) -> void:
	scenePath = _s
	type = _t
	pass
