extends Control
class_name Pl_AmmoDisplayerController

@export var magAmmoLabel: Label
@export var reserveAmmoLabel: Label
var currentWeaponIdx: int = 0


func _init() -> void:
	Nodes.player.connect("WeaponChanged", onWeaponChanged)
	Nodes.player.connect("PlayerShot", onPlayerShot)
	Nodes.player.connect("ReloadEnd", onReloadEnd)
	pass


func updateLabels() -> void:
	var ammoId: int = Nodes.player.currentWeapon.ammoId if (is_instance_valid(Nodes.player.currentWeapon)) else 0
	magAmmoLabel.text = str(Nodes.player.inventory.weapons[currentWeaponIdx].magazineAmmo)
	reserveAmmoLabel.text = "/" + str(Nodes.player.inventory["reserveAmmo"][ammoId]) # aqui tem que ser eh o id da municao que a arma usa
	pass


func onWeaponChanged(_newWeapon: PlayerWeapon) -> void:
	currentWeaponIdx = Nodes.player.getWeaponIdxOnInventory(_newWeapon)
	updateLabels()
	pass

func onPlayerShot(_recoilStrength: float) -> void:
	updateLabels()
	pass

func onReloadEnd() -> void:
	updateLabels()
	pass
