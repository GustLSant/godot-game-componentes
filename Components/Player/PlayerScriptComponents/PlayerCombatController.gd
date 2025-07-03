extends Node
class_name PlayerCombatController

var isAiming: bool = false


func _process(delta: float) -> void:
	getAimInput()
	pass


func getAimInput() -> void:
	var holdMode: bool = true
	
	if(holdMode):
		isAiming = Input.is_action_pressed("Aim")
	else:
		if(Input.is_action_just_pressed("Aim")): isAiming = !isAiming
	pass
