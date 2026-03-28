extends Node
class_name PlWp_InventoryController

@onready var player: Player = Nodes.player
@export var weapon: PlayerWeapon


func _init() -> void:
	Nodes.player.connect("ChangeWeapon", onChangeWeapon)
	Nodes.player.connect("ReplaceWeapon", onReplaceWeapon)
	self.connect("tree_exiting", onTreeExiting)
	pass


func _ready() -> void:
	getSelfIdxOnInventory()
	getStartAttachments()
	setActive(weapon.isActive)
	pass


func getSelfIdxOnInventory() -> void:
	for i in range(player.inventory.weapons.size()):
		if(player.inventory.weapons[i].get_instance_id() == weapon.get_instance_id()):
			weapon.selfIdxOnInventory = i
			return
	
	if(weapon.selfIdxOnInventory == -1): printerr("Não foi possível achar o idx da arma atual // id: ", weapon.id, " // weapon name: ", weapon.name, " // inventory: ", player.inventory.weapons)
	pass


func getStartAttachments() -> void:
	if(not weapon.startWeaponAttachmentsLoadout): return
	for attSlot: T_AttachmentSlot.ENUM in weapon.startWeaponAttachmentsLoadout.paths.keys():
		if(weapon.startWeaponAttachmentsLoadout.paths[attSlot]):
			var att: WeaponAttachment = load(weapon.startWeaponAttachmentsLoadout.paths[attSlot]).instantiate()
			addAttachment(att, attSlot)
	pass


func addAttachment(_newAttachment: WeaponAttachment, _attSlot: T_AttachmentSlot.ENUM) -> void:
	_newAttachment.slot = _attSlot
	_newAttachment.attachedWeapon = weapon
	weapon.attachmentNodes[_attSlot].call_deferred("add_child", _newAttachment)
	weapon.attachments[_attSlot] = _newAttachment
	pass


func setActive(_value: bool) -> void:
	weapon.isActive = _value
	weapon.visible = _value
	if(_value):
		Nodes.player.currentWeapon = weapon
		Nodes.player.emit_signal("WeaponChanged", weapon)
		setParametersOnPlayerState()
	pass


func onChangeWeapon(_request: T_WeaponChangeRequest) -> void:
	setActive(_request.newWeapon == weapon)
	pass


func onReplaceWeapon(_request: T_WeaponReplaceRequest) -> void:
	if(_request.oldWeapon == weapon): weapon.queue_free()
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
	
	player.recoverDurationMultiplier = weapon.recoverDurationMultiplier
	player.recoilPosZStrength  = weapon.recoilPosZStrength
	player.recoilPosYStrength  = weapon.recoilPosYStrength
	player.recoilRotXStrength  = weapon.recoilRotXStrength
	player.recoilRotZStrength  = weapon.recoilRotZStrength
	pass


func onTreeExiting() -> void:
	player.inventory["reserveAmmo"][weapon.ammoId] += weapon.magazineAmmo # devolvendo a municao restante do pente para o inventario
	pass
