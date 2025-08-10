extends Node
class_name PlayerInventoryController

@onready var playerState: PlayerState = Nodes.playerState


func _init() -> void:
	Nodes.playerState.connect("PickupWeapon", onPickupWeapon)
	Nodes.playerState.connect("ChangeWeapon", onChangeWeapon)
	Nodes.playerState.connect("EquipAttachment", onEquipAttachment)
	pass


func _ready() -> void:
	getStartItems()
	pass


func _process(_delta: float) -> void:
	getInputChangeWeapon()
	pass


func getStartItems() -> void:
	for w: String in GameplayManager.startInventory["weapons"]:
		var newWeaponData: T_WeaponData = T_WeaponData.new(load(w).instantiate())
		newWeaponData.magazineAmmo = GameplayManager.startInventory["magazineAmmo"][0]
		Nodes.playerState.inventory.reserveAmmo = GameplayManager.startInventory["reserveAmmo"]
		
		Nodes.playerState.emit_signal("PickupWeapon", newWeaponData, true)
	
	for att: String in GameplayManager.startInventory["weaponAttachments"]:
		Nodes.playerState.emit_signal("EquipAttachment", load(att).instantiate(), playerState.inventory.weapons[0].instance.id)
	pass


func onPickupWeapon(_newWeaponData: T_WeaponData, _spawnOnPlayerModel: bool) -> void:
	if(playerState.inventory.weapons.size() < playerState.weaponsInventoryMaxSize):
		playerState.inventory.weapons.append(_newWeaponData)
		
		if(playerState.inventory.weapons.size() == 1): # se nao tinha arma, ja equipa a que pegou
			playerState.emit_signal("ChangeWeapon", playerState.inventory.weapons[0])
	else:
		replaceCurrentWeapon(_newWeaponData)
	pass


func replaceCurrentWeapon(_newWeaponData: T_WeaponData) -> void:
	var currentWeaponIdx: int = playerState.getCurrentWeaponIdx()
	var previousWeaponId: int = playerState.currentWeapon.id
	
	playerState.currentWeapon.queue_free()
	playerState.inventory.weapons[currentWeaponIdx] = _newWeaponData
	playerState.emit_signal("ChangeWeapon", playerState.inventory.weapons[currentWeaponIdx])
	
	var previousPickupWeaponScenePath: String = ""
	match previousWeaponId:
		1: previousPickupWeaponScenePath = "res://Components/Player/PlayerWeapon/PickupWeapon_01.tscn"
		2: previousPickupWeaponScenePath = "res://Components/Player/PlayerWeapon/PickupWeapon_02.tscn"
	
	var previousPickupWeaponScene: InteractiveObject = load(previousPickupWeaponScenePath).instantiate()
	previousPickupWeaponScene.position = Nodes.player.global_position
	Nodes.mainNode.add_child(previousPickupWeaponScene)
	pass


func getInputChangeWeapon() -> void:
	if(Input.is_action_just_pressed("ChangeNextWeapon")): handleInputChangeWeaponByDirection(1)
	elif(Input.is_action_just_pressed("ChangePreviousWeapon")): handleInputChangeWeaponByDirection(-1)
	
	if(Input.is_action_just_pressed("ChangeFirstWeapon")): handleInputChangeWeaponByIdx(0)
	if(Input.is_action_just_pressed("ChangeSecondWeapon")): handleInputChangeWeaponByIdx(1)
	if(Input.is_action_just_pressed("ChangeThirdWeapon")): handleInputChangeWeaponByIdx(2)
	pass


func handleInputChangeWeaponByDirection(_changeDirection: int) -> void:
	if(playerState.inventory["weapons"].size() <= 1): return
	if(playerState.currentWeapon == null): playerState.emit_signal("ChangeWeapon", playerState.inventory["weapons"][0]) # sem nenhuma arma equipada, equipa a primeira do inventario
	
	var currentWeaponIdx: int = playerState.getCurrentWeaponIdx()
	
	var nextWeaponIdx: int = currentWeaponIdx + _changeDirection
	if(nextWeaponIdx > playerState.inventory["weapons"].size()-1):
		nextWeaponIdx = 0
	elif(nextWeaponIdx < 0):
		nextWeaponIdx = playerState.inventory["weapons"].size()-1
	
	playerState.emit_signal("ChangeWeapon", playerState.inventory["weapons"][nextWeaponIdx])
	pass


func handleInputChangeWeaponByIdx(_idx: int) -> void:
	if(_idx > playerState.inventory["weapons"].size()-1): return
	
	if(playerState.currentWeapon == playerState.inventory["weapons"][_idx]): return
	
	if(playerState.inventory["weapons"][_idx] != null):
		playerState.emit_signal("ChangeWeapon", playerState.inventory["weapons"][_idx])
	pass


func onChangeWeapon(_nextCurrentWeaponData: T_WeaponData) -> void:
	playerState.currentWeapon = _nextCurrentWeaponData.instance
	pass


func onEquipAttachment(_attachment: WeaponAttachment, _weaponIdx: int) -> void:
	playerState.inventory.weapons[0].attachments.device_r = _attachment # o idx ta hardcoded
	pass
