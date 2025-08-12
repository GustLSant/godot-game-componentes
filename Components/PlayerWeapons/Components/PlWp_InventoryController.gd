extends Node
class_name PlWp_InventoryController

@onready var player: Player = Nodes.player
@export var wpState: PlayerWeapon


func _init() -> void:
	Nodes.player.connect("ChangeWeapon", onChangeWeapon)
	Nodes.player.connect("EquipAttachment", onEquipAttachment)
	self.connect("tree_exiting", onTreeExiting)
	pass


func _ready() -> void:
	getSelfIdxOnInventory()
	setActive(wpState.isActive)
	getStartAttachments()
	#talvez fosse bom recarregar o pente aqui ja no inicio do jogo, pra n comecar com a arma vazia
	pass


func getSelfIdxOnInventory() -> void:
	for i in range(player.inventory.weapons.size()):
		if(player.inventory.weapons[i].id == wpState.id):
			wpState.selfIdxOnInventory = i
			return
	
	if(wpState.selfIdxOnInventory == -1): printerr("Não foi possível achar o idx da arma atual // id: ", wpState.id, " // weapon name: ", wpState.name, " // inventory: ", player.inventory.weapons)
	pass


func setActive(_value: bool) -> void:
	wpState.isActive = _value
	wpState.visible = _value
	if(_value): setParametersOnPlayerState()
	pass


func getStartAttachments() -> void:
	var attachmentsFullString: String =  GameplayManager.startInventory.weaponAttachments[wpState.selfIdxOnInventory]
	var attachmentPaths: PackedStringArray = attachmentsFullString.split(" ", false)
	for att: String in attachmentPaths:
		var attachment: WeaponAttachment = load(att).instantiate()
		wpState.attachmentNodes[attachment.type].add_child(attachment)
	pass


func onChangeWeapon(_newWeaponData: PlayerWeapon) -> void:
	setActive(wpState.id == _newWeaponData.id)
	pass


func onEquipAttachment(_attachment: WeaponAttachment, _weaponId: int) -> void:
	if(wpState.id == _weaponId):
		wpState.attachmentNodes[_attachment.type].add_child(_attachment)
	pass


func setParametersOnPlayerState() -> void:
	player = Nodes.player # pq essa funcao pode ser chamada antes do ready
	
	player.damage = wpState.damage
	player.fireRate = wpState.fireRate
	player.magazineSize = wpState.magazineSize
	player.fireSpread = wpState.fireSpread
	
	player.armsDefaultPosition = wpState.armsDefaultPosition
	player.armsAimPosition = wpState.armsAimPosition
	player.aimFOV = wpState.aimFOV
	
	player.recoverFactor = wpState.recoverFactor
	player.recoilShakeStrength = wpState.recoilShakeStrength
	player.recoilPosZStrength = wpState.recoilPosZStrength
	player.recoilRotXStrength = wpState.recoilRotXStrength
	player.recoilRotZStrength = wpState.recoilRotZStrength
	pass


func onTreeExiting() -> void:
	player.inventory["reserveAmmo"][wpState.ammoId] += wpState.magazineAmmo # devolvendo a municao restante do pente para o inventario
	pass
