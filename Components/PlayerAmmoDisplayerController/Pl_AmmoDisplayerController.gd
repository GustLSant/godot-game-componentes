extends Control
class_name Pl_AmmoDisplayerController

@export var magAmmoLabel: Label
@export var reserveAmmoLabel: Label
var currentWeaponIdx: int = 0


func _init() -> void:
	GameplayManager.connect('GameStarted', onGameStarted)
	pass


func onGameStarted() -> void:
	Nodes.player.call_deferred('connect', "WeaponChanged", onWeaponChanged)
	Nodes.player.call_deferred('connect', "PlayerShot", onPlayerShot)
	Nodes.player.call_deferred('connect', "ReloadEnd", onReloadEnd)
	pass


func updateLabels() -> void:
	var ammoId: int = Nodes.player.currentWeapon.ammoId if (is_instance_valid(Nodes.player.currentWeapon)) else 0
	magAmmoLabel.text = str(Nodes.player.inventory.weapons[currentWeaponIdx].magazineAmmo)
	reserveAmmoLabel.text = "/" + str(Nodes.player.inventory["reserveAmmo"][ammoId]) # aqui tem que ser eh o id da municao que a arma usa
	pass


func onWeaponChanged(_newWeapon: PlayerWeapon) -> void:
	currentWeaponIdx = Nodes.player.getWeaponIdxOnInventory(_newWeapon)
	call_deferred("updateLabels") # precisa ser deferred pq quando a arma é trocada, ela emite o WeaponChanged antes de ser destruida, e a arma so devolve a municao para o inventario quando ela está se destruindo
	pass

func onPlayerShot(_payload: T_PlayerShotPayload) -> void:
	updateLabels()
	pass

func onReloadEnd() -> void:
	updateLabels()
	pass
