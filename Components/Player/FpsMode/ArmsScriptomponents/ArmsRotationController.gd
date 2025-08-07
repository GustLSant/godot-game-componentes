extends Node
class_name ArmsRotationController

@export var pivot: Node3D
@onready var playerState: PlayerState = Nodes.playerState

const ARMS_ROT_SPEED: float = 30.0
const ARMS_AIM_ROT_SPEED: float = 40.0

var delta: float = 0.016


func _process(_delta: float) -> void:
	delta = _delta
	handleRotation()
	pass


func handleRotation() -> void:
	var speed: float = int(playerState.isAiming) * ARMS_AIM_ROT_SPEED + int(not playerState.isAiming) * ARMS_ROT_SPEED
	speed = speed * delta
	speed = min(speed, 1.0)
	speed = 1.0
	pivot.global_rotation.y = lerp_angle(pivot.global_rotation.y, playerState.currentPivotRot.global_rotation.y, speed)
	pivot.global_rotation.x = lerp_angle(pivot.global_rotation.x, playerState.currentPivotRot.global_rotation.x, speed)
	pass
