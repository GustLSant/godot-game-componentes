extends Node
class_name PlWp_AimController

@onready var playerState: PlayerState = Nodes.playerState
@export var wpState: PlayerWeaponController


func _process(_delta: float) -> void:
	if(not wpState.isActive): return
	handleAimInput()
	pass


func handleAimInput() -> void:
	if(Settings.aimHoldMode):
		playerState.isAiming = Input.is_action_pressed("Aim")
	else:
		if(Input.is_action_just_pressed("Aim")): playerState.isAiming = !playerState.isAiming
	
	playerState.isAiming = playerState.isAiming and (not playerState.isReloading)
	pass
