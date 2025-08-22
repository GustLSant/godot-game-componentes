extends Node
class_name Pl_InventoryController

@onready var player: Player = Nodes.player


func _init() -> void:
	Nodes.player.connect("PickupWeapon", onPickupWeapon)
	pass


func _ready() -> void:
	getStartWeapons()
	pass


func _process(_delta: float) -> void:
	getInputChangeWeapon()
	pass


func getStartWeapons() -> void:
	for i in range(GameplayManager.startInventory.weapons.size()):
		var newWeaponData: PlayerWeapon = load(GameplayManager.startInventory.weapons[i]).instantiate()
		newWeaponData.startWeaponAttachmentsLoadout = GameplayManager.startInventory.weaponAttachments[i]
		Nodes.player.inventory.reserveAmmo = GameplayManager.startInventory["reserveAmmo"]
		Nodes.player.emit_signal("PickupWeapon", newWeaponData)
	pass


func onPickupWeapon(_newWeapon: PlayerWeapon) -> void:
	if(player.inventory.weapons.size() < player.weaponsInventoryMaxSize):
		player.inventory.weapons.append(_newWeapon)
		
		if(player.inventory.weapons.size() == 1): # se nao tinha arma, ja equipa a que pegou
			player.emit_signal("TryChangeWeapon", player.inventory.weapons[0])
	else:
		replaceCurrentWeapon(_newWeapon)
	pass


func replaceCurrentWeapon(_newWeapon: PlayerWeapon) -> void:
	var currentWeaponIdx: int = player.getCurrentWeaponIdx()
	var previousWeaponId: int = player.currentWeapon.id
	
	spawnWeaponPickUp(previousWeaponId)
	
	player.currentWeapon.queue_free()
	player.inventory.weapons[currentWeaponIdx] = _newWeapon
	player.emit_signal("TryChangeWeapon", player.inventory.weapons[currentWeaponIdx])
	pass


func spawnWeaponPickUp(_weaponId: int) -> void:
	var pickupWeaponScene: WeaponPickupController = load("res://Components/PlayerWeapons/WeaponPickup.tscn").instantiate()
	pickupWeaponScene.referenceWeapon = player.currentWeapon
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
	if(player.currentWeapon == null): player.emit_signal("TryChangeWeapon", player.inventory.weapons[0]) # sem nenhuma arma equipada, equipa a primeira do inventario
	
	var currentWeaponIdx: int = player.getCurrentWeaponIdx()
	
	var nextWeaponIdx: int = currentWeaponIdx + _changeDirection
	if(nextWeaponIdx > player.inventory.weapons.size()-1):
		nextWeaponIdx = 0
	elif(nextWeaponIdx < 0):
		nextWeaponIdx = player.inventory.weapons.size()-1
	
	player.emit_signal("TryChangeWeapon", player.inventory.weapons[nextWeaponIdx])
	pass


func handleInputChangeWeaponByIdx(_idx: int) -> void:
	if(_idx > player.inventory.weapons.size()-1): return
	
	if(player.currentWeapon == player.inventory.weapons[_idx]): return
	
	if(player.inventory.weapons[_idx] != null):
		player.emit_signal("TryChangeWeapon", player.inventory.weapons[_idx])
	pass
