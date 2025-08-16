extends Node
class_name PlWp_InventoryController

@onready var player: Player = Nodes.player
@export var weapon: PlayerWeapon


func _init() -> void:
	Nodes.player.connect("ChangeWeapon", onChangeWeapon)
	self.connect("tree_exiting", onTreeExiting)
	pass


func _ready() -> void:
	getSelfIdxOnInventory()
	getStartAttachments()
	setActive(weapon.isActive)
	#talvez fosse bom recarregar o pente aqui ja no inicio do jogo, pra n comecar com a arma vazia
	pass


func getSelfIdxOnInventory() -> void:
	for i in range(player.inventory.weapons.size()):
		if(player.inventory.weapons[i].get_instance_id() == weapon.get_instance_id()):
			weapon.selfIdxOnInventory = i
			return
	
	if(weapon.selfIdxOnInventory == -1): printerr("Não foi possível achar o idx da arma atual // id: ", weapon.id, " // weapon name: ", weapon.name, " // inventory: ", player.inventory.weapons)
	pass


func setActive(_value: bool) -> void:
	weapon.isActive = _value
	weapon.visible = _value
	if(_value):
		Nodes.player.currentWeapon = weapon
		Nodes.player.emit_signal("WeaponChanged", weapon)
		setParametersOnPlayerState()
	pass


func getStartAttachments() -> void:
	var startWeaponAttachmentsLoadout: T_StartWeaponAttachmentLoadout = GameplayManager.startInventory.weaponAttachments[weapon.selfIdxOnInventory]
	
	for attType: T_AttachmentType.ENUM in startWeaponAttachmentsLoadout.paths.keys():
		if(startWeaponAttachmentsLoadout.paths[attType]):
			var att: WeaponAttachment = load(startWeaponAttachmentsLoadout.paths[attType]).instantiate()
			att.type = attType
			att.attachedWeapon = weapon
			weapon.attachmentNodes[attType].add_child(att)
			weapon.attachments[attType] = att
	
	weapon.attachmentsRecoilMultiplierFactor = getAttachmentsRecoilMultiplierFactor()
	pass


func onChangeWeapon(_newWeapon: PlayerWeapon) -> void:
	setActive(weapon.get_instance_id() == _newWeapon.get_instance_id())
	pass


func setParametersOnPlayerState() -> void:
	player = Nodes.player
	player.damage = weapon.damage
	player.fireRate = weapon.fireRate
	player.fireSpread = weapon.fireSpread
	if(weapon.attachments[T_AttachmentType.ENUM.MAGAZINE]):
		player.magazineSize = weapon.attachments[T_AttachmentType.ENUM.MAGAZINE].magazineSize
	else:
		player.magazineSize = weapon.magazineSize
	
	player.armsDefaultPosition = weapon.armsDefaultPosition
	
	if(weapon.attachments[T_AttachmentType.ENUM.SIGHT]):
		player.armsAimPosition = weapon.armsAimPosition + Vector3.UP * weapon.attachments[T_AttachmentType.ENUM.SIGHT].posAimOffsetByWeaponId[weapon.id]
		player.aimFOV = weapon.attachments[T_AttachmentType.ENUM.SIGHT].aimFOV
		player.fpsBodyAimFOV = weapon.attachments[T_AttachmentType.ENUM.SIGHT].fpsBodyAimFOV
	else:
		player.armsAimPosition = weapon.armsAimPosition
		player.aimFOV = weapon.aimFOV
		player.fpsBodyAimFOV = weapon.fpsBodyAimFOV
	
	player.recoverFactor = weapon.recoverFactor
	player.recoilShakeStrength = weapon.recoilShakeStrength * weapon.attachmentsRecoilMultiplierFactor
	player.recoilPosZStrength  = weapon.recoilPosZStrength  * weapon.attachmentsRecoilMultiplierFactor
	player.recoilPosYStrength  = weapon.recoilPosYStrength  * weapon.attachmentsRecoilMultiplierFactor
	player.recoilRotXStrength  = weapon.recoilRotXStrength  * weapon.attachmentsRecoilMultiplierFactor
	player.recoilRotZStrength  = weapon.recoilRotZStrength  * weapon.attachmentsRecoilMultiplierFactor
	pass


func getAttachmentsRecoilMultiplierFactor() -> float:
	var attRecoilMultiplierFactor: float = 1.0
	
	if(weapon.attachments[T_AttachmentType.ENUM.GRIP]):
		attRecoilMultiplierFactor = weapon.attachments[T_AttachmentType.ENUM.GRIP].recoilMultiplierFactor
	
	if(weapon.attachments[T_AttachmentType.ENUM.BARREL]):
		attRecoilMultiplierFactor -= 1.0 - weapon.attachments[T_AttachmentType.ENUM.BARREL].recoilMultiplierFactor
	
	return attRecoilMultiplierFactor


func onTreeExiting() -> void:
	player.inventory["reserveAmmo"][weapon.ammoId] += weapon.magazineAmmo # devolvendo a municao restante do pente para o inventario
	pass
