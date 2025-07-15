extends Node
class_name PlayerState

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
var currentCamera: PlayerCameraController
var currentCameraMode = CAMERA_MODE.FPS
signal CameraModeChanged(_newMode: CAMERA_MODE)


# CombatController
var isAiming: bool = false
var attackRate: float = 0.1
signal PlayerShot(_recoilStrength: float)


# Weapons
var damage: float = 20.0
var armsDefaultPosition: Vector3 = Vector3(0.03, -0.05, 0.01)
var armsAimPosition: Vector3 = Vector3(0.0, -0.0285, 0.02)
#const armsDefaultPosition: Vector3 = Vector3(0.03, -0.05, -0.02)
#const armsAimPosition: Vector3 = Vector3(0.0, -0.0285, -0.01)
var aimFOV: float = 45.0
var recoilShakeStrength: float = 1.0
var recoilPosZStrength: float = 1.0
var recoilRotXStrength: float = 1.0
var recoilRotZStrength: float = 1.0
