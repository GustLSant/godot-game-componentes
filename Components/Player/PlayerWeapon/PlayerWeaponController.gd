extends Node
class_name PlayerWeaponController

@onready var playerState: PlayerState = Nodes.playerState

@export var damage: float = 20.0
@export var fireRate: float = 0.15
@export var magazineSize: int = 30
@export var fireSpread: float = 2.5
@export var reloadTime: float = 2.5

@export_category("Nodes")
@export var shotRayCast: RayCast3D
@export var barrelNode: Node3D
@export var attachmentNodes: Array[Node3D]

@export_category("Aim Variables")
@export var armsDefaultPosition: Vector3 = Vector3(0.6, -0.8, -0.2)
@export var armsAimPosition: Vector3 = Vector3(0.0, -0.5, -0.2)
@export var aimFOV: float = 45.0

@export_category("Recoil Variables")
@export var recoverFactor: float = 1.0
@export var cameraRecoilStrength: float = 1.0
@export var recoilShakeStrength: float = 1.0
@export var recoilPosZStrength: float = 1.0
@export var recoilRotXStrength: float = 1.0
@export var recoilRotZStrength: float = 1.0

@export_category("ID")
@export var id: int = 0
@export var ammoId: int = 0

var isActive: bool = false
var currentFireCooldown: float = 0.0
var canTriggerReloadEndSignal: bool = false
var selfIdxOnInventory: int = -1
var delta: float = 0.016


func _process(_delta: float) -> void:
	if(not isActive): return
	delta = _delta
	handleFireRate()
	handleReload()
	pass


func handleReload() -> void:
	if(Input.is_action_just_pressed("Reload")):
		if(playerState.isReloading or playerState.inventory.weapons[selfIdxOnInventory].magazineAmmo >= playerState.magazineSize or playerState.inventory["reserveAmmo"][ammoId] <= 0): return
		playerState.isReloading = true
		playerState.currentReloadTime = reloadTime
		canTriggerReloadEndSignal = true
	
	if(playerState.currentReloadTime > 0.0):
		playerState.currentReloadTime -= 1 * delta
	else:
		if(canTriggerReloadEndSignal):
			playerState.isReloading = false
			var ammoAmount: int = min(
				abs(playerState.magazineSize - playerState.inventory.weapons[selfIdxOnInventory].magazineAmmo), 
				playerState.inventory["reserveAmmo"][ammoId]
				)
			playerState.inventory.weapons[selfIdxOnInventory].magazineAmmo += ammoAmount
			playerState.inventory["reserveAmmo"][ammoId] -= ammoAmount
			playerState.emit_signal("ReloadEnd")
			canTriggerReloadEndSignal = false
	pass


func handleFireRate() -> void:
	currentFireCooldown -= 1 * delta
	pass
