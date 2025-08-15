extends Node
class_name PlWp_InventoryController

@onready var player: Player = Nodes.player
@export var wpState: PlayerWeapon


func _init() -> void:
	Nodes.player.connect("ChangeWeapon", onChangeWeapon)
	self.connect("tree_exiting", onTreeExiting)
	pass


func _ready() -> void:
	getSelfIdxOnInventory()
	getStartAttachments()
	setActive(wpState.isActive)
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
	var startWeaponAttachmentsLoadout: T_StartWeaponAttachmentLoadout = GameplayManager.startInventory.weaponAttachments[wpState.selfIdxOnInventory]
	
	for attType: T_AttachmentType.ENUM in startWeaponAttachmentsLoadout.paths.keys():
		if(startWeaponAttachmentsLoadout.paths[attType]):
			var att: WeaponAttachment = load(startWeaponAttachmentsLoadout.paths[attType]).instantiate()
			att.type = attType
			att.attachedWeaponId = wpState.id
			wpState.attachmentNodes[attType].add_child(att)
			wpState.attachments[attType] = att
			print(wpState.attachments)
	pass


func onChangeWeapon(_newWeaponData: PlayerWeapon) -> void:
	setActive(wpState.id == _newWeaponData.id)
	pass


func onEquipAttachment(_attachment: WeaponAttachment, _weaponId: int) -> void:
	if(wpState.id == _weaponId):
		wpState.attachmentNodes[_attachment.type].add_child(_attachment)
	pass


func setParametersOnPlayerState() -> void:
	player = Nodes.player
	player.damage = wpState.damage
	player.fireRate = wpState.fireRate
	player.magazineSize = wpState.magazineSize
	player.fireSpread = wpState.fireSpread
	
	player.armsDefaultPosition = wpState.armsDefaultPosition
	
	if(wpState.attachments[T_AttachmentType.ENUM.SIGHT]):
		player.armsAimPosition = wpState.armsAimPosition + Vector3.UP * wpState.attachments[T_AttachmentType.ENUM.SIGHT].posAimOffsetByWeaponId[wpState.id]
		player.aimFOV = wpState.attachments[T_AttachmentType.ENUM.SIGHT].aimFOV
		player.fpsBodyAimFOV = wpState.attachments[T_AttachmentType.ENUM.SIGHT].fpsBodyAimFOV
	else:
		player.armsAimPosition = wpState.armsAimPosition
		player.aimFOV = wpState.aimFOV
		player.fpsBodyAimFOV = wpState.fpsBodyAimFOV
	
	player.recoverFactor = wpState.recoverFactor
	player.recoilShakeStrength = wpState.recoilShakeStrength
	player.recoilPosZStrength = wpState.recoilPosZStrength
	player.recoilPosYStrength = wpState.recoilPosYStrength
	player.recoilRotXStrength = wpState.recoilRotXStrength
	player.recoilRotZStrength = wpState.recoilRotZStrength
	pass


func onTreeExiting() -> void:
	player.inventory["reserveAmmo"][wpState.ammoId] += wpState.magazineAmmo # devolvendo a municao restante do pente para o inventario
	pass
