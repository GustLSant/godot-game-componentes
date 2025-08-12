extends Node
class_name PlayerWeapon

@onready var player: Player = Nodes.player

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
var selfIdxOnInventory: int = -1
var attachments: T_WeaponAttachments = T_WeaponAttachments.new()

# fire rate
var currentFireCooldown: float = 0.0

# ammo / reload
var canTriggerReloadEndSignal: bool = false
var magazineAmmo: int = 0
