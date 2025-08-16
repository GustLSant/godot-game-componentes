extends Node
class_name PlWp_ReloadController

@onready var player: Player = Nodes.player
@export var weapon: PlayerWeapon

var delta: float = 0.016


func _process(_delta: float) -> void:
	if(not weapon.isActive): return
	delta = _delta
	handleReload()
	pass


func handleReload() -> void:
	if(Input.is_action_just_pressed("Reload")):
		if(checkCannotReload()): return
		player.isReloading = true
		player.currentReloadTime = weapon.reloadTime
		weapon.canTriggerReloadEndSignal = true
	
	if(player.currentReloadTime > 0.0):
		player.currentReloadTime -= 1 * delta
	else:
		if(weapon.canTriggerReloadEndSignal):
			player.isReloading = false
			var ammoAmount: int = getAmmoAmountOnReload()
			weapon.magazineAmmo += ammoAmount
			player.inventory["reserveAmmo"][weapon.ammoId] -= ammoAmount
			player.emit_signal("ReloadEnd")
			weapon.canTriggerReloadEndSignal = false
	pass


func checkCannotReload() -> bool:
	return (player.isReloading or weapon.magazineAmmo >= player.magazineSize or player.inventory["reserveAmmo"][weapon.ammoId] <= 0)


func getAmmoAmountOnReload() -> int:
	return min(abs(player.magazineSize - weapon.magazineAmmo), player.inventory["reserveAmmo"][weapon.ammoId])
