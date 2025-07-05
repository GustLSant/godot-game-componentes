extends Node
class_name PlayerState

# Reference
@export var player: CharacterBody3D

# Movement Controller
var velocity:Vector3 = Vector3.ZERO
var isSprinting:bool = false

# Camera Manager
enum CAMERA_MODE {FPS, TPS}
var currentPivotRot: Marker3D = null
var currentCameraMode = CAMERA_MODE.FPS
signal CameraModeChanged(_newMode: CAMERA_MODE)

# CombatController
var isAiming: bool = false
