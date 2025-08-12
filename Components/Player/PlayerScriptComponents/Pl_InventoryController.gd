extends Node
class_name Pl_InventoryController

@onready var player: Player = Nodes.player


func _init() -> void:
	Nodes.player.connect("PickupWeapon", onPickupWeapon)
	Nodes.player.connect("ChangeWeapon", onChangeWeapon)
	Nodes.player.connect("EquipAttachment", onEquipAttachment)
	pass


func _ready() -> void:
	getStartWeapons()
	pass


func _process(_delta: float) -> void:
	getInputChangeWeapon()
	pass


func getStartWeapons() -> void:
	for i in range(GameplayManager.startInventory["weapons"].size()):
		var newWeaponData: PlayerWeapon = load(GameplayManager.startInventory["weapons"][i]).instantiate()
		Nodes.player.inventory.reserveAmmo = GameplayManager.startInventory["reserveAmmo"]
		Nodes.player.emit_signal("PickupWeapon", newWeaponData, true)
	pass


func onPickupWeapon(_newWeapon: PlayerWeapon, _spawnOnPlayerModel: bool) -> void:
	if(player.inventory.weapons.size() < player.weaponsInventoryMaxSize):
		player.inventory.weapons.append(_newWeapon)
		
		if(player.inventory.weapons.size() == 1): # se nao tinha arma, ja equipa a que pegou
			player.emit_signal("ChangeWeapon", player.inventory.weapons[0])
	else:
		replaceCurrentWeapon(_newWeapon)
	pass


func replaceCurrentWeapon(_newWeapon: PlayerWeapon) -> void:
	var currentWeaponIdx: int = player.getCurrentWeaponIdx()
	var previousWeaponId: int = player.currentWeapon.id
	
	player.currentWeapon.queue_free()
	player.inventory.weapons[currentWeaponIdx] = _newWeapon
	player.emit_signal("ChangeWeapon", player.inventory.weapons[currentWeaponIdx])
	
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
	if(player.inventory["weapons"].size() <= 1): return
	if(player.currentWeapon == null): player.emit_signal("ChangeWeapon", player.inventory["weapons"][0]) # sem nenhuma arma equipada, equipa a primeira do inventario
	
	var currentWeaponIdx: int = player.getCurrentWeaponIdx()
	
	var nextWeaponIdx: int = currentWeaponIdx + _changeDirection
	if(nextWeaponIdx > player.inventory["weapons"].size()-1):
		nextWeaponIdx = 0
	elif(nextWeaponIdx < 0):
		nextWeaponIdx = player.inventory["weapons"].size()-1
	
	player.emit_signal("ChangeWeapon", player.inventory["weapons"][nextWeaponIdx])
	pass


func handleInputChangeWeaponByIdx(_idx: int) -> void:
	if(_idx > player.inventory["weapons"].size()-1): return
	
	if(player.currentWeapon == player.inventory["weapons"][_idx]): return
	
	if(player.inventory["weapons"][_idx] != null):
		player.emit_signal("ChangeWeapon", player.inventory["weapons"][_idx])
	pass


func onChangeWeapon(_nextCurrentWeapon: PlayerWeapon) -> void:
	player.currentWeapon = _nextCurrentWeapon
	pass


func onEquipAttachment(_attachment: WeaponAttachment, _weaponIdx: int) -> void:
	player.inventory.weapons[0].attachments.device_r = _attachment # o idx ta hardcoded
	pass
