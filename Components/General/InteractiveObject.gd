extends Node3D
class_name InteractiveObject

@export var description: String = ""
@export var actionKey: String = "F"


func checkAction() -> void:
	if(Input.is_action_just_pressed('Interaction')):
		action()
	pass


func action() -> void:
	pass
