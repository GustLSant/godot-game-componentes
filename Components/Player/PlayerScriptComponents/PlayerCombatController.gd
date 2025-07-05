extends Node
class_name PlayerCombatController

@export var playerState: PlayerState


func _process(delta: float) -> void:
	getAimInput()
	if(Input.is_action_just_pressed("Shoot")):
		playerState.emit_signal("PlayerShot", 1.0)
	pass


func getAimInput() -> void:
	var holdMode: bool = true
	
	if(holdMode):
		playerState.isAiming = Input.is_action_pressed("Aim")
	else:
		if(Input.is_action_just_pressed("Aim")): playerState.isAiming = !playerState.isAiming
	pass
