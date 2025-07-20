extends Node
class_name PlayerInventoryController

@onready var playerState: PlayerState = Nodes.playerState


func _init() -> void:
	Nodes.playerState.connect("TryPickupWeapon", onTryPickupWeapon)
	Nodes.playerState.connect("PickupWeapon", onPickupWeapon)
	Nodes.playerState.connect("ChangeWeapon", onChangeWeapon)
	pass


func _process(_delta: float) -> void:
	getInputChangeWeapon()
	pass


func onTryPickupWeapon(_newWeaponScenePath: String) -> void:
	if(playerState.inventory.size() < playerState.inventoryMaxSize):
		var newWeapon: PlayerWeaponController = load(_newWeaponScenePath).instantiate()
		playerState.emit_signal("PickupWeapon", newWeapon, true)
	pass


func onPickupWeapon(_newWeapon: PlayerWeaponController, _spawnOnPlayerModel: bool) -> void:
	playerState.inventory.append(_newWeapon)
	
	if(playerState.inventory.size() == 1): # se nao tinha arma, ja equipa a que pegou
		playerState.emit_signal("ChangeWeapon", playerState.inventory[0])
	pass


func getInputChangeWeapon() -> void:
	if(Input.is_action_just_pressed("ChangeNextWeapon")): handleInputChangeWeapon(1)
	elif(Input.is_action_just_pressed("ChangePreviousWeapon")): handleInputChangeWeapon(-1)
	pass


func handleInputChangeWeapon(_changeDirection: int) -> void:
	if(playerState.inventory.size() <= 1): return
	if(playerState.currentWeapon == null): playerState.emit_signal("ChangeWeapon", playerState.inventory[0]) # sem nenhuma arma equipada, equipa a primeira do inventario
	
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
	
	playerState.emit_signal("ChangeWeapon", playerState.inventory[nextWeaponIdx])
	pass


func onChangeWeapon(_nextCurrentWeapon: PlayerWeaponController) -> void:
	playerState.currentWeapon = _nextCurrentWeapon
	pass
