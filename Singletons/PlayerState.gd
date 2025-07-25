extends Node
class_name PlayerState


func _init() -> void:
	Nodes.playerState = self
	pass


func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("Test")):
		print(inventory)


# Movement Controller
var inputVecMovement: Vector2 = Vector2.ZERO
var velocity:Vector3 = Vector3.ZERO
var isSprinting:bool = false
var isOnFloor: bool = true


# Camera Manager
enum CAMERA_MODE {FPS, TPS}
var currentPivotRot: Marker3D = null
var currentCameraController: PlayerCameraController
var currentCameraMode = CAMERA_MODE.FPS
signal CameraModeChanged(_newMode: CAMERA_MODE)


# Health Controller
var maxHealth:int = 100
var health:int = maxHealth
signal DamageTaken(_damage: float)


# Inventory
var inventory: Dictionary[String, Array] = {
	'weapons' = [],
	'weaponsAmmo' = [0, 0, 0, 0, 0], # municao de cada arma relacionada pelo idx dos arrays
	'reserveAmmo' = [20, 0, 0, 0],   # cada indice eh um tipo de municao
	'keyItems' = [],
	'misc' = []
}
#var inventory: Array[PlayerWeaponController] = []
var inventoryMaxSize: int = 3
var currentWeapon: PlayerWeaponController = null
signal PickupWeapon(_newWeaponScene: PlayerWeaponController, _spawnOnPlayerModel: bool)
signal TryChangeWeapon(_newWeaponScene: PlayerWeaponController)
signal ChangeWeapon(_newWeaponScene: PlayerWeaponController)
signal ReloadEnd()


# Weapon Controller
var isAiming: bool = false
var isReloading: bool = false
var currentReloadTime: float = 0.0
signal PlayerShot(_recoilStrength: float)

# Weapons Parameters
var damage: float = 20.0
var fireRate: float = 0.1
var magazineSize: int = 20
var armsDefaultPosition: Vector3 = Vector3(0.6, -0.65, -1.25) # short: Vector3(0.6, -0.65, -1.75)
var armsAimPosition: Vector3 = Vector3(0.0, -0.33, -1.0)      # short: Vector3(0.0, -0.33, -1.0)
var aimFOV: float = 45.0
var recoverFactor: float = 1.0
var recoilShakeStrength: float = 1.0
var recoilPosZStrength: float = 1.0
var recoilRotXStrength: float = 1.0
var recoilRotZStrength: float = 1.0


func getCurrentWeaponIdx() -> int:
	var result: int = -1
	
	for i in range(inventory["weapons"].size()):
		if(inventory["weapons"][i] == currentWeapon):
			result = i
			break
	
	return result
