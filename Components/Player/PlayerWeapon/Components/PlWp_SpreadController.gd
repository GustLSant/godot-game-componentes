extends Node
class_name PlWp_SpreadController

@onready var playerState: PlayerState = Nodes.playerState
@export var wpState: PlayerWeaponController


func _process(_delta: float) -> void:
	if(not wpState.isActive): return
	handleFireSpread()
	pass


func handleFireSpread() -> void:
	var walkingMultiplier: float =   int(Nodes.player.velocity != Vector3.ZERO) * 1.5  + int(Nodes.player.velocity == Vector3.ZERO) * 1.0
	var sprintingMultiplier: float = int(playerState.isSprinting)               * 2.0  + int(not playerState.isSprinting) * 1.0
	var aimingMultiplier: float =    int(playerState.isAiming)                  * 0.05 + int(not playerState.isAiming) * 1.0
	var crouchMultiplier: float =    int(playerState.isCrouched)                * playerState.CROUCH_MULTIPLIER_FACTOR + int(not playerState.isCrouched) * 1.0
	
	playerState.fireSpread = wpState.fireSpread * walkingMultiplier * sprintingMultiplier * aimingMultiplier * crouchMultiplier
	pass
