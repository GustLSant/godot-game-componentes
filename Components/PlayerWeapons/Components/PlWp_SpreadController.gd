extends Node
class_name PlWp_SpreadController

@onready var player: Player = Nodes.player
@export var wpState: PlayerWeapon


func _process(_delta: float) -> void:
	if(not wpState.isActive): return
	handleFireSpread()
	pass


func handleFireSpread() -> void:
	var walkingMultiplier: float =   int(Nodes.player.velocity != Vector3.ZERO) * 1.5  + int(Nodes.player.velocity == Vector3.ZERO) * 1.0
	var sprintingMultiplier: float = int(player.isSprinting)               * 2.0  + int(not player.isSprinting) * 1.0
	var aimingMultiplier: float =    int(player.isAiming)                  * 0.05 + int(not player.isAiming) * 1.0
	var crouchMultiplier: float =    int(player.isCrouched)                * player.CROUCH_MULTIPLIER_FACTOR + int(not player.isCrouched) * 1.0
	
	player.fireSpread = wpState.fireSpread * walkingMultiplier * sprintingMultiplier * aimingMultiplier * crouchMultiplier
	pass
