extends Control

@export var magAmmoLabel: Label
@export var reserveAmmoLabel: Label
var currentWeaponIdx: int = 0


func _init() -> void:
	Nodes.player.connect("ChangeWeapon", onChangeWeapon)
	Nodes.player.connect("PlayerShot", onPlayerShot)
	Nodes.player.connect("ReloadEnd", onReloadEnd)
	pass


func getCurrentWeaponIdx() -> int:
	return max(Nodes.player.getCurrentWeaponIdx(), 0) # se nao tiver nenhuma arma, vai pegar o primeiro idx

func updateLabels() -> void:
	var ammoId: int = Nodes.player.currentWeapon.ammoId if (is_instance_valid(Nodes.player.currentWeapon)) else 0
	magAmmoLabel.text = str(Nodes.player.inventory.weapons[currentWeaponIdx].magazineAmmo)
	reserveAmmoLabel.text = "/" + str(Nodes.player.inventory["reserveAmmo"][ammoId]) # aqui tem que ser eh o id da municao que a arma usa
	pass


func onChangeWeapon(_newWeaponData: PlayerWeapon) -> void:
	currentWeaponIdx = getCurrentWeaponIdx()
	updateLabels()
	pass

func onPlayerShot(_recoilStrength: float) -> void:
	updateLabels()
	pass

func onReloadEnd() -> void:
	updateLabels()
	pass
