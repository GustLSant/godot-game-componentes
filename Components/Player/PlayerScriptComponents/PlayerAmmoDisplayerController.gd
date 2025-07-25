extends Control

@export var magAmmoLabel: Label
@export var reserveAmmoLabel: Label
var currentWeaponIdx: int = 0


func _init() -> void:
	Nodes.playerState.connect("ChangeWeapon", onChangeWeapon)
	Nodes.playerState.connect("PlayerShot", onPlayerShot)
	Nodes.playerState.connect("ReloadEnd", onReloadEnd)
	pass


func _ready() -> void:
	magAmmoLabel.text = "0"
	reserveAmmoLabel.text = "/0"
	pass


func getCurrentWeaponIdx() -> int:
	return max(Nodes.playerState.getCurrentWeaponIdx(), 0) # se nao tiver nenhuma arma, vai pegar o primeiro idx

func updateLabels() -> void:
	magAmmoLabel.text = str(Nodes.playerState.inventory["weaponsAmmo"][currentWeaponIdx])
	reserveAmmoLabel.text = "/" + str(Nodes.playerState.inventory["reserveAmmo"][currentWeaponIdx]) # aqui tem que ser eh o id da municao que a arma usa
	pass



func onChangeWeapon(_newWeapon: PlayerWeaponController) -> void:
	currentWeaponIdx = getCurrentWeaponIdx()
	updateLabels()
	pass

func onPlayerShot(_recoilStrength: float) -> void:
	updateLabels()
	pass

func onReloadEnd() -> void:
	updateLabels()
	pass
