extends PlayerCameraController

@export var base: Node3D
@export var bodyRefRot: Marker3D
@export var player: CharacterBody3D
@export var body: Node3D
@export var playerMovementController: PlayerMovementController

var delta:float = 0.016
var pDelta:float = 0.016


func _process(delta: float) -> void:
	handleBodyRotation()
	pass


func _physics_process(_delta: float) -> void:
	pDelta = _delta
	handlePlayerFollowing()
	pass


func handleBodyRotation() -> void:
	var targetRotation: float = bodyRefRot.rotation.y
	if(player.velocity.x != 0.0 or player.velocity.z != 0.0):
		bodyRefRot.look_at(body.global_position + player.velocity)
		body.rotation.y = lerp_angle(body.rotation.y, targetRotation, 10 * delta)
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
