extends PlayerModelController
class_name PlayerTpsBodyController

@export var pivotRefRot: Marker3D
var delta: float = 0.016


func _process(_delta: float) -> void:
	delta = _delta
	handleRotation()
	handleAimBehaviour()
	pass


func handleRotation() -> void:
	if(playerState.player.velocity.x != 0.0 or playerState.player.velocity.z != 0.0):
		pivotRefRot.look_at(self.global_position + playerState.player.velocity)
		pivotRot.global_rotation.y = lerp_angle(pivotRot.global_rotation.y, pivotRefRot.global_rotation.y, 10 * delta)
	pass


func handleAimBehaviour() -> void:
	$PivotRot/MeshInstance3D.rotation_degrees.x = -20.0 * int(playerState.isAiming)
	pivotRot.global_rotation.y = int(playerState.isAiming) * playerState.currentPivotRot.global_rotation.y + int(not playerState.isAiming) * pivotRot.global_rotation.y
	pass
