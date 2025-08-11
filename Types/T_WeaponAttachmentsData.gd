extends Node
class_name T_WeaponAttachmentsData

var sight: Object = null
var grip: Object = null
var magazine: Object = null
var device_l: Object = null
var device_r: Object = null
var barrel: Object = null


func _init(_sight: Object = null, _grip: Object = null, _magazine: Object = null, _deviceL: Object = null, _deviceR: Object = null, _barrel: Object = null) -> void:
	sight = _sight
	grip = _grip
	magazine = _magazine
	device_l = _deviceL
	device_r = _deviceR
	barrel = _barrel
	pass
