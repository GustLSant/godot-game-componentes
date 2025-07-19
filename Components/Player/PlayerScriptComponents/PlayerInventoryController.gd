extends Node
class_name PlayerInventoryController

@onready var playerState: PlayerState = Nodes.playerState


func _ready() -> void:
	playerState.connect("TryPickupWeapon", onTryPickupWeapon)
	pass


func _process(delta: float) -> void:
	getInputChangeWeapon()
	pass


func onTryPickupWeapon(_newWeaponScenePath: String) -> void:
	if(playerState.inventory.size() < playerState.inventoryMaxSize):
		var newWeapon: PlayerWeaponController = load(_newWeaponScenePath).instantiate()
		playerState.inventory.append(newWeapon)
		
		if(playerState.inventory.size() == 1): # se nao tinha arma, ja equipa a que pegou
			changeWeapon(playerState.inventory[0])
		else:
			newWeapon.setActive(false)
		
		playerState.emit_signal("PickupWeapon", newWeapon)
	pass


func getInputChangeWeapon() -> void:
	if(Input.is_action_just_pressed("ChangeNextWeapon")):
		handleInputChangeWeapon(1)
	elif(Input.is_action_just_pressed("ChangePreviousWeapon")):
		handleInputChangeWeapon(-1)
	pass


func handleInputChangeWeapon(_changeDirection: int) -> void:
	if(playerState.inventory.size() <= 1): return
	if(playerState.currentWeapon == null): changeWeapon(playerState.inventory[0]) # sem nenhuma arma equipada, equipa a primeira do inventario
	
	var currentWeaponIdx: int = 0
	for i in range(playerState.inventory.size()):
		if(playerState.inventory[i] == playerState.currentWeapon):
			currentWeaponIdx = i
			break
	
	var nextWeaponIdx: int = currentWeaponIdx + _changeDirection
	if(nextWeaponIdx > playerState.inventory.size()-1):
		nextWeaponIdx = 0
	elif(nextWeaponIdx < 0):
		nextWeaponIdx = playerState.inventory.size()-1
	
	changeWeapon(playerState.inventory[nextWeaponIdx])
	pass


func changeWeapon(_nextCurrentWeapon: PlayerWeaponController) -> void:
	for w: PlayerWeaponController in playerState.inventory:
		w.setActive(false)
	_nextCurrentWeapon.setActive(true)
	pass
