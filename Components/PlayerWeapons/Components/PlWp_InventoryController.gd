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
			addAttachment(att, attType)
	
	pass


func addAttachment(_newAttachment: WeaponAttachment, _attType: T_AttachmentType.ENUM) -> void:
	_newAttachment.type = _attType
	_newAttachment.attachedWeapon = weapon
	weapon.attachmentNodes[_attType].add_child(_newAttachment)
	weapon.attachments[_attType] = _newAttachment
	pass


func onChangeWeapon(_newWeapon: PlayerWeapon) -> void:
	setActive(weapon.get_instance_id() == _newWeapon.get_instance_id())
	pass


func setParametersOnPlayerState() -> void:
	player = Nodes.player
	player.damage = weapon.damage
	player.fireRate = weapon.fireRate
	player.fireSpread = weapon.fireSpread
	player.magazineSize = weapon.magazineSize
	
	player.armsDefaultPosition = weapon.armsDefaultPosition
	player.armsAimPosition = weapon.armsAimPosition
	player.aimFOV = weapon.aimFOV
	player.fpsBodyAimFOV = weapon.fpsBodyAimFOV
	
	player.recoverFactor = weapon.recoverFactor
	player.recoilShakeStrength = weapon.recoilShakeStrength
	player.recoilPosZStrength  = weapon.recoilPosZStrength
	player.recoilPosYStrength  = weapon.recoilPosYStrength
	player.recoilRotXStrength  = weapon.recoilRotXStrength
	player.recoilRotZStrength  = weapon.recoilRotZStrength
	pass


func onTreeExiting() -> void:
	player.inventory["reserveAmmo"][weapon.ammoId] += weapon.magazineAmmo # devolvendo a municao restante do pente para o inventario
	pass
