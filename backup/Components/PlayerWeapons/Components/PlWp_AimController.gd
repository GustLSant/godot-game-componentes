extends Node
class_name PlWp_AimController

@onready var player: Player = Nodes.player
@export var weapon: PlayerWeapon


func _process(_delta: float) -> void:
	if(not weapon.isActive): return
	handleAimInput()
	pass


func handleAimInput() -> void:
	if(Settings.aimHoldMode):
		player.isAiming = Input.is_action_pressed("Aim")
	else:
		if(Input.is_action_just_pressed("Aim")): player.isAiming = !player.isAiming
	
	player.isAiming = player.isAiming and (not player.isReloading)
	pass
