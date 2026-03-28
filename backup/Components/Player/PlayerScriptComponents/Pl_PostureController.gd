extends Node
class_name Pl_PostureController

var wasCrouching: bool = false


func _process(_delta: float) -> void:
	handleCrouchInput()
	handleCrouchPosture()
	pass


func handleCrouchInput() -> void:
	if(Settings.crouchHoldMode):
		Nodes.player.isCrouched = Input.is_action_pressed("Crouch")
	else:
		if(Input.is_action_just_pressed("Crouch")): Nodes.player.isCrouched = !Nodes.player.isCrouched
	
	if(Nodes.player.isCrouched and not wasCrouching):
		Nodes.player.emit_signal("PlayerCrouch")
	
	wasCrouching = Nodes.player.isCrouched
	pass


func handleCrouchPosture() -> void:
	Nodes.player.isCrouched = Nodes.player.isCrouched and (Nodes.player.isOnFloor)
	Nodes.player.isCrouched = Nodes.player.isCrouched and (not Nodes.player.isSprinting)
	pass
