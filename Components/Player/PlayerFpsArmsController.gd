extends Node3D

const ARMS_ROT_SPEED:float = 25.0
@export var fpsCamera: PlayerFpsCameraController
@export var pivotRot: Marker3D

var delta:float = 0.016


func _process(_delta: float) -> void:
	delta = _delta
	handleRotation()
	pass


func handleRotation() -> void:
	pivotRot.global_rotation.y = lerp_angle(pivotRot.global_rotation.y, fpsCamera.pivotRot.global_rotation.y, ARMS_ROT_SPEED*delta)
	pivotRot.global_rotation.x = lerp_angle(pivotRot.global_rotation.x, fpsCamera.pivotRot.global_rotation.x, ARMS_ROT_SPEED*delta)
	pass


func setActive(_value: bool, _rotation: Vector3 = Vector3.ZERO) -> void:
	set_process(_value)
	set_physics_process(_value)
	self.visible = _value
	pivotRot.rotation = _rotation
	pass
