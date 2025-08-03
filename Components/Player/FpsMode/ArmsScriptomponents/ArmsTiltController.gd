extends Node
class_name ArmsTiltController

@export var pivot: Node3D
@onready var playerState: PlayerState = Nodes.playerState

const TILT_SPEED: float = 7.5
var delta: float = 0.016


func _process(_delta: float) -> void:
	delta = _delta
	handleTiltEffect()
	pass


func handleTiltEffect() -> void:
	var targetRotationZ: float = playerState.inputVecMovement.x * -7.5
	var targetRotationX: float = playerState.inputVecMovement.y * 2.5
	
	targetRotationZ *= int(playerState.isAiming) * 0.25 + int(not playerState.isAiming) * 1.0
	targetRotationX *= int(playerState.isAiming) * 0.25 + int(not playerState.isAiming) * 1.0
	
	pivot.rotation_degrees.z = lerp(pivot.rotation_degrees.z, targetRotationZ, TILT_SPEED * delta)
	pivot.rotation_degrees.x = lerp(pivot.rotation_degrees.x, targetRotationX, TILT_SPEED * delta)
	pass
