extends Node3D
class_name PlayerTpsBodyController

@export var player: CharacterBody3D
@export var tpsCamera: PlayerTpsCameraController
@export var playerCombatController: PlayerCombatController

@export_category("Internal Variables")
@export var pivotRot: Marker3D
@export var pivotRefRot: Marker3D

var delta: float = 0.016


func _process(_delta: float) -> void:
	delta = _delta
	handleRotation()
	handleAimBehaviour()
	pass


func handleRotation() -> void:
	if(player.velocity.x != 0.0 or player.velocity.z != 0.0):
		pivotRefRot.look_at(self.global_position + player.velocity)
		pivotRot.rotation.y = lerp_angle(pivotRot.rotation.y, pivotRefRot.rotation.y, 10 * delta)
	pass


func handleAimBehaviour() -> void:
	$PivotRot/MeshInstance3D.rotation_degrees.x = -20.0 * int(playerCombatController.isAiming)
	pivotRot.rotation = tpsCamera.pivotRot.rotation
	pass


func setActive(_value: bool, _rotation: Vector3 = Vector3.ZERO) -> void:
	set_process(_value)
	set_physics_process(_value)
	self.visible = _value
	pivotRot.rotation.y = _rotation.y
	pass
