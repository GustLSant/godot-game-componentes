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
		playerState.emit_signal("TryChangeWeapon", playerState.inventory[0])
	pass


func getInputChangeWeapon() -> void:
	if(Input.is_action_just_pressed("ChangeNextWeapon")): handleInputChangeWeaponByDirection(1)
	elif(Input.is_action_just_pressed("ChangePreviousWeapon")): handleInputChangeWeaponByDirection(-1)
	
	if(Input.is_action_just_pressed("ChangeFirstWeapon")): handleInputChangeWeaponByIdx(0)
	if(Input.is_action_just_pressed("ChangeSecondWeapon")): handleInputChangeWeaponByIdx(1)
	if(Input.is_action_just_pressed("ChangeThirdWeapon")): handleInputChangeWeaponByIdx(2)
	pass


func handleInputChangeWeaponByDirection(_changeDirection: int) -> void:
	if(playerState.inventory.size() <= 1): return
	if(playerState.currentWeapon == null): playerState.emit_signal("TryChangeWeapon", playerState.inventory[0]) # sem nenhuma arma equipada, equipa a primeira do inventario
	
	var currentWeaponIdx: int = getCurrentWeaponIdx()
	
	var nextWeaponIdx: int = currentWeaponIdx + _changeDirection
	if(nextWeaponIdx > playerState.inventory.size()-1):
		nextWeaponIdx = 0
	elif(nextWeaponIdx < 0):
		nextWeaponIdx = playerState.inventory.size()-1
	
	playerState.emit_signal("TryChangeWeapon", playerState.inventory[nextWeaponIdx])
	pass


func handleInputChangeWeaponByIdx(_idx: int) -> void:
	if(_idx > playerState.inventory.size()-1): return
	
	if(playerState.currentWeapon == playerState.inventory[_idx]): return
	
	if(playerState.inventory[_idx] != null):
		playerState.emit_signal("TryChangeWeapon", playerState.inventory[_idx])
	pass


func getCurrentWeaponIdx() -> int:
	var result: int = -1
	
	for i in range(playerState.inventory.size()):
		if(playerState.inventory[i] == playerState.currentWeapon):
			result = i
			break
	
	return result


func onChangeWeapon(_nextCurrentWeapon: PlayerWeaponController) -> void:
	playerState.currentWeapon = _nextCurrentWeapon
	pass
