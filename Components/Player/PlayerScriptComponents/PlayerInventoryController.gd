extends Node
class_name PlayerInventoryController


func _ready() -> void:
	PlayerState.connect("TryPickupWeapon", onTryPickupWeapon)
	pass


func _process(delta: float) -> void:
	getInputChangeWeapon()
	pass


func onTryPickupWeapon(_newWeaponScenePath: String) -> void:
	if(PlayerState.inventory.size() < PlayerState.inventoryMaxSize):
		var newWeapon: PlayerWeaponController = load(_newWeaponScenePath).instantiate()
		PlayerState.inventory.append(newWeapon)
		
		if(PlayerState.inventory.size() == 1): # se nao tinha arma, ja equipa a que pegou
			changeWeapon(PlayerState.inventory[0])
		else:
			newWeapon.setActive(false)
		
		PlayerState.emit_signal("PickupWeapon", newWeapon)
	pass


func getInputChangeWeapon() -> void:
	if(Input.is_action_just_pressed("ChangeNextWeapon")):
		handleInputChangeWeapon(1)
	elif(Input.is_action_just_pressed("ChangePreviousWeapon")):
		handleInputChangeWeapon(-1)
	pass


func handleInputChangeWeapon(_changeDirection: int) -> void:
	if(PlayerState.inventory.size() <= 1): return
	if(PlayerState.currentWeapon == null): changeWeapon(PlayerState.inventory[0]) # sem nenhuma arma equipada, equipa a primeira do inventario
	
	var currentWeaponIdx: int = 0
	for i in range(PlayerState.inventory.size()):
		if(PlayerState.inventory[i] == PlayerState.currentWeapon):
			currentWeaponIdx = i
			break
	
	var nextWeaponIdx: int = currentWeaponIdx + _changeDirection
	if(nextWeaponIdx > PlayerState.inventory.size()-1):
		nextWeaponIdx = 0
	elif(nextWeaponIdx < 0):
		nextWeaponIdx = PlayerState.inventory.size()-1
	
	changeWeapon(PlayerState.inventory[nextWeaponIdx])
	pass


func changeWeapon(_nextCurrentWeapon: PlayerWeaponController) -> void:
	for w: PlayerWeaponController in PlayerState.inventory:
		w.setActive(false)
	_nextCurrentWeapon.setActive(true)
	pass
