extends Node
class_name PlayerPostureController

var wasCrouching: bool = false


func _process(delta: float) -> void:
	handleCrouchInput()
	handleCrouchPosture()
	pass


func handleCrouchInput() -> void:
	if(Settings.crouchHoldMode):
		Nodes.playerState.isCrouched = Input.is_action_pressed("Crouch")
	else:
		if(Input.is_action_just_pressed("Crouch")): Nodes.playerState.isCrouched = !Nodes.playerState.isCrouched
	
	if(Nodes.playerState.isCrouched and not wasCrouching):
		Nodes.playerState.emit_signal("PlayerCrouch")
	
	wasCrouching = Nodes.playerState.isCrouched
	pass


func handleCrouchPosture() -> void:
	Nodes.playerState.isCrouched = Nodes.playerState.isCrouched and (Nodes.playerState.isOnFloor)
	Nodes.playerState.isCrouched = Nodes.playerState.isCrouched and (not Nodes.playerState.isSprinting)
	pass
