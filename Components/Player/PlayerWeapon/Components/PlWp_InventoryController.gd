extends Node
class_name PlWp_InventoryController

@onready var playerState: PlayerState = Nodes.playerState
@export var wpState: PlayerWeaponController


func _init() -> void:
	Nodes.playerState.connect("ChangeWeapon", onChangeWeapon)
	Nodes.playerState.connect("EquipAttachment", onEquipAttachment)
	self.connect("tree_exiting", onTreeExiting)
	pass


func _ready() -> void:
	getSelfIdxOnInventory()
	setActive(wpState.isActive)
	pass


func getSelfIdxOnInventory() -> void:
	for i in range(playerState.inventory.weapons.size()):
		if(playerState.inventory.weapons[i].instance.id == wpState.id):
			wpState.selfIdxOnInventory = i
			return
	
	if(wpState.selfIdxOnInventory == -1): printerr("Não foi possível achar o idx da arma atual // id: ", wpState.id, " // weapon name: ", wpState.name, " // inventory: ", playerState.inventory.weapons)
	pass


func setActive(_value: bool) -> void:
	wpState.isActive = _value
	wpState.visible = _value
	if(_value): setParametersOnPlayerState()
	pass


func onChangeWeapon(_newWeaponData: T_WeaponData) -> void:
	setActive(wpState.id == _newWeaponData.instance.id)
	pass


func onEquipAttachment(_attachment: WeaponAttachment, _weaponId: int) -> void:
	if(wpState.id == _weaponId):
		wpState.attachmentNodes[_attachment.type].add_child(_attachment)
	pass


func setParametersOnPlayerState() -> void:
	playerState = Nodes.playerState # pq essa funcao pode ser chamada antes do ready
	
	playerState.damage = wpState.damage
	playerState.fireRate = wpState.fireRate
	playerState.magazineSize = wpState.magazineSize
	playerState.fireSpread = wpState.fireSpread
	
	playerState.armsDefaultPosition = wpState.armsDefaultPosition
	playerState.armsAimPosition = wpState.armsAimPosition
	playerState.aimFOV = wpState.aimFOV
	
	playerState.recoverFactor = wpState.recoverFactor
	playerState.recoilShakeStrength = wpState.recoilShakeStrength
	playerState.recoilPosZStrength = wpState.recoilPosZStrength
	playerState.recoilRotXStrength = wpState.recoilRotXStrength
	playerState.recoilRotZStrength = wpState.recoilRotZStrength
	pass


func onTreeExiting() -> void:
	playerState.inventory["reserveAmmo"][wpState.ammoId] += playerState.inventory.weapons[wpState.selfIdxOnInventory].magazineAmmo # devolvendo a municao restante do pente para o inventario
	playerState.inventory.weapons[wpState.selfIdxOnInventory].magazineAmmo = 0
	pass
