extends CharacterBody3D
class_name Player


func _init() -> void:
	Nodes.player = self
	pass


# Movement Controller
var inputVecMovement: Vector2 = Vector2.ZERO
var isSprinting:bool = false
var isOnFloor: bool = true
const SPRINT_MULTIPLIER_FACTOR: float = 2.0


# Posture Controller
var isCrouched: bool = false
const CROUCH_HEIGHT: float = -0.8
const CROUCH_SPEED: float = 10.0
const CROUCH_MULTIPLIER_FACTOR: float = 0.75
signal PlayerCrouch()


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
@export var weaponSockets: Array[Node3D] = []
var inventory: T_Inventory = T_Inventory.new()
var weaponsInventoryMaxSize: int = 2
var currentWeapon: PlayerWeapon = null
signal RequestInteractAnim (_callback: Callable)
signal TryPickupWeapon     (_request: T_WeaponPickupRequest)
signal PickupWeapon        (_request: T_WeaponPickupRequest)
signal WeaponPickedUp      (_request: T_WeaponPickupRequest)
signal ChangeWeapon        (_request: T_WeaponChangeRequest)
signal WeaponChanged       (_newWeapon: PlayerWeapon)


# Weapon Controller
var isAiming: bool = false
var isReloading: bool = false
var currentReloadTime: float = 0.0
const AIM_MULTIPLIER_FACTOR: float = 0.5
const AIM_SPEED: float = 10.0
signal PlayerShot(_recoilStrength: float)
signal ReloadEnd()

# Weapons Parameters
var damage: float = 20.0
var fireRate: float = 0.1
var magazineSize: int = 20
var fireSpread: float = 2.5
var armsDefaultPosition: Vector3 = Vector3(0.6, -0.8, -0.2)
var armsAimPosition: Vector3 = Vector3(0.0, -0.5, -0.2)
var aimFOV: float = 45.0
var fpsBodyAimFOV: float = 45.0
var recoverDurationMultiplier: float = 1.0
var recoilShakeStrength: float = 1.0
var recoilPosZStrength: float = 1.0
var recoilPosYStrength: float = 1.0
var recoilRotXStrength: float = 1.0
var recoilRotZStrength: float = 1.0


func getCurrentWeaponIdx() -> int:
	var result: int = -1
	
	for i in range(inventory.weapons.size()):
		if(inventory.weapons[i] == currentWeapon):
			result = i
			break
	
	return result


func getWeaponIdxOnInventory(_weapon: PlayerWeapon) -> int:
	var result: int = -1
	
	for i in range(inventory.weapons.size()):
		if(inventory.weapons[i] == _weapon):
			result = i
			break
	
	return result
