extends Node
class_name PlayerState

# Reference
@export var player: CharacterBody3D

# Movement Controller
var inputVecMovement: Vector2 = Vector2.ZERO
var velocity:Vector3 = Vector3.ZERO
var isSprinting:bool = false

# Camera Manager
enum CAMERA_MODE {FPS, TPS}
var currentPivotRot: Marker3D = null
var currentCameraMode = CAMERA_MODE.FPS
signal CameraModeChanged(_newMode: CAMERA_MODE)

# CombatController
var isAiming: bool = false
signal PlayerShot(_recoilStrength: float)

# Weapons
var damage: float = 20.0
var fireInterval: float = 0.3
var recoilShakeStrength: float = 1.0
var recoilPosZStrength: float = 1.0
var recoilRotXStrength: float = 1.0
var recoilRotZStrength: float = 1.0
