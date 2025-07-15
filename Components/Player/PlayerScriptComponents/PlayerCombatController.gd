extends Node
class_name PlayerCombatController

@export var playerState: PlayerState
var currentAttackCooldown: float = 0.0

var delta: float = 0.016


func _process(_delta: float) -> void:
	delta = _delta
	getAimInput()
	handleShootInput()
	handleAtackRate()
	pass


func getAimInput() -> void:
	if(S_Settings.aimHoldMode):
		playerState.isAiming = Input.is_action_pressed("Aim")
	else:
		if(Input.is_action_just_pressed("Aim")): playerState.isAiming = !playerState.isAiming
	pass


func handleShootInput() -> void:
	if(Input.is_action_pressed("Shoot") and currentAttackCooldown <= 0.0):
		playerState.emit_signal("PlayerShot", 1.0)
		currentAttackCooldown = playerState.attackRate
	pass


func handleAtackRate() -> void:
	currentAttackCooldown -= 1 * delta
	pass
