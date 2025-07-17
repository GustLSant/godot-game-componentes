extends Node

# Reference
@export var player: CharacterBody3D


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
var inventory: Array[Node3D] = []
var inventoryMaxSize: int = 3
var currentWeapon: PlayerWeaponController = null
signal TryPickupWeapon(_newWeaponScenePath: String)
signal WeaponChanged(_newWeapon: PlayerWeaponController)


# Weapon Controller
var isAiming: bool = false
signal PlayerShot(_recoilStrength: float)

# Weapons Parameters
var damage: float = 20.0
var fireRate: float = 0.1
var armsDefaultPosition: Vector3 = Vector3(0.6, -1.0, 0.2) # short: Vector3(0.6, -1.0, -0.4)
var armsAimPosition: Vector3 = Vector3(0.0, -0.57, 0.4)    # short: Vector3(0.0, -0.57, -0.2)
var aimFOV: float = 45.0
var recoilShakeStrength: float = 1.0
var recoilPosZStrength: float = 1.0
var recoilRotXStrength: float = 1.0
var recoilRotZStrength: float = 1.0
