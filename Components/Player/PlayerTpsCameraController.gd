extends PlayerCameraController

@export var base: Node3D
@export var player: CharacterBody3D
@export var playerMovementController: PlayerMovementController

var pDelta:float = 0.016


func _physics_process(_delta: float) -> void:
	pDelta = _delta
	handlePlayerFollowing()
	pass


func handlePlayerFollowing() -> void:
	base.global_position = lerp(
		base.global_position,
		player.global_position,
		10 * pDelta
		)
	pass


func onActiveUpdate(_value) -> void:
	base.global_position = player.global_position
	pass
