extends Node
class_name PlWp_ReloadController

@onready var player: Player = Nodes.player
@export var wpState: PlayerWeapon

var delta: float = 0.016


func _process(_delta: float) -> void:
	if(not wpState.isActive): return
	delta = _delta
	handleReload()
	pass


func handleReload() -> void:
	if(Input.is_action_just_pressed("Reload")):
		if(checkCannotReload()): return
		player.isReloading = true
		player.currentReloadTime = wpState.reloadTime
		wpState.canTriggerReloadEndSignal = true
	
	if(player.currentReloadTime > 0.0):
		player.currentReloadTime -= 1 * delta
	else:
		if(wpState.canTriggerReloadEndSignal):
			player.isReloading = false
			var ammoAmount: int = getAmmoAmountOnReload()
			wpState.magazineAmmo += ammoAmount
			player.inventory["reserveAmmo"][wpState.ammoId] -= ammoAmount
			player.emit_signal("ReloadEnd")
			wpState.canTriggerReloadEndSignal = false
	pass


func checkCannotReload() -> bool:
	return (player.isReloading or wpState.magazineAmmo >= player.magazineSize or player.inventory["reserveAmmo"][wpState.ammoId] <= 0)


func getAmmoAmountOnReload() -> int:
	return min(abs(player.magazineSize - wpState.magazineAmmo), player.inventory["reserveAmmo"][wpState.ammoId])
