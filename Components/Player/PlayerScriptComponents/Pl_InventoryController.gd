extends Node
class_name Pl_InventoryController

@onready var player: Player = Nodes.player


func _init() -> void:
	Nodes.player.connect("TryPickupWeapon", onTryPickupWeapon)
	Nodes.player.connect("PickupWeapon", onPickupWeapon)
	pass


func _ready() -> void:
	getStartWeapons()
	pass


func _process(_delta: float) -> void:
	getInputChangeWeapon()
	pass


func getStartWeapons() -> void:
	Nodes.player.inventory.reserveAmmo = GameplayManager.startInventory["reserveAmmo"]
	
	for i in range(GameplayManager.startInventory.weapons.size()):
		var newWeaponData: PlayerWeapon = load(GameplayManager.startInventory.weapons[i]).instantiate()
		newWeaponData.startWeaponAttachmentsLoadout = GameplayManager.startInventory.weaponAttachments[i]
		
		var request: T_WeaponPickupRequest = T_WeaponPickupRequest.new()
		request.newWeapon = newWeaponData
		
		Nodes.player.emit_signal("PickupWeapon", request)
	pass


func onTryPickupWeapon(_request: T_WeaponPickupRequest) -> void:
	if(player.inventory.weapons.size() < player.weaponsInventoryMaxSize):
		Nodes.player.emit_signal("PickupWeapon", _request)
	else:
		_request.isReplacement = true
		Nodes.player.emit_signal("PickupWeapon", _request)
	pass


func onPickupWeapon(_request: T_WeaponPickupRequest) -> void:
	if(not _request.isReplacement):
		player.inventory.weapons.append(_request.newWeapon)
		for socket: Node3D in player.weaponSockets: socket.add_child(_request.newWeapon)
		player.emit_signal("WeaponPickedUp", _request)
		
		if(player.inventory.weapons.size() == 1): # se nao tinha arma, ja equipa a que pegou
			var changeRequest: T_WeaponChangeRequest = T_WeaponChangeRequest.new()
			changeRequest.newWeapon = _request.newWeapon
			changeRequest.weaponPickupToBeDeleted = _request.weaponPickup
			requestWeaponChange(changeRequest)
	else:
		replaceCurrentWeapon(_request)
	pass


func replaceCurrentWeapon(_request: T_WeaponPickupRequest) -> void:
	var currentWeaponIdx: int = player.getCurrentWeaponIdx()
	
	var changeRequest: T_WeaponChangeRequest = T_WeaponChangeRequest.new()
	changeRequest.newWeapon = _request.newWeapon
	changeRequest.weaponPickupToBeDeleted = _request.weaponPickup
	
	spawnWeaponPickUp(player.currentWeapon)
	changeRequest.weaponToBeDeleted = player.currentWeapon
	
	player.inventory.weapons[currentWeaponIdx] = _request.newWeapon
	for socket: Node3D in player.weaponSockets: socket.add_child(_request.newWeapon)
	
	requestWeaponChange(changeRequest)
	pass


func spawnWeaponPickUp(_replacedWeapon: PlayerWeapon) -> void:
	var pickupWeaponScene: WeaponPickup = load("res://Components/PlayerWeapons/WeaponPickup.tscn").instantiate()
	pickupWeaponScene.referenceWeapon = _replacedWeapon
	Nodes.mainNode.add_child(pickupWeaponScene)
	pass


func getInputChangeWeapon() -> void:
	if(Input.is_action_just_pressed("ChangeNextWeapon")): handleInputChangeWeaponByDirection(1)
	elif(Input.is_action_just_pressed("ChangePreviousWeapon")): handleInputChangeWeaponByDirection(-1)
	
	if(Input.is_action_just_pressed("ChangeFirstWeapon")): handleInputChangeWeaponByIdx(0)
	if(Input.is_action_just_pressed("ChangeSecondWeapon")): handleInputChangeWeaponByIdx(1)
	if(Input.is_action_just_pressed("ChangeThirdWeapon")): handleInputChangeWeaponByIdx(2)
	pass


func handleInputChangeWeaponByDirection(_changeDirection: int) -> void:
	if(player.inventory.weapons.size() <= 1): return
	if(player.currentWeapon == null):
		var request: T_WeaponChangeRequest = T_WeaponChangeRequest.new()
		request.newWeapon = player.inventory.weapons[0]
		requestWeaponChange(request) # sem nenhuma arma equipada, equipa a primeira do inventario
	
	var currentWeaponIdx: int = player.getCurrentWeaponIdx()
	
	var nextWeaponIdx: int = currentWeaponIdx + _changeDirection
	if(nextWeaponIdx > player.inventory.weapons.size()-1):
		nextWeaponIdx = 0
	elif(nextWeaponIdx < 0):
		nextWeaponIdx = player.inventory.weapons.size()-1
	
	var request: T_WeaponChangeRequest = T_WeaponChangeRequest.new()
	request.newWeapon = player.inventory.weapons[nextWeaponIdx]
	requestWeaponChange(request)
	pass


func handleInputChangeWeaponByIdx(_idx: int) -> void:
	if(_idx > player.inventory.weapons.size()-1): return
	
	if(player.currentWeapon == player.inventory.weapons[_idx]): return
	
	if(player.inventory.weapons[_idx] != null):
		var request: T_WeaponChangeRequest = T_WeaponChangeRequest.new()
		request.newWeapon = player.inventory.weapons[_idx]
		requestWeaponChange(request)
	pass


func requestWeaponChange(_request) -> void:
	player.emit_signal(
		"RequestInteractAnim",
		func(): player.emit_signal("ChangeWeapon", _request)
	)
	pass
