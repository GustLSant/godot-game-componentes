extends PlayerCameraController

const ARMS_ROT_SPEED:float = 25.0
@export var arms: Node3D
@export var armsPivotRot: Marker3D

var delta:float = 0.016


func _process(_delta: float) -> void:
	delta = _delta
	handleArmsRotation()
	pass


func handleArmsRotation() -> void:
	armsPivotRot.global_position = pivotRot.global_position
	armsPivotRot.global_rotation.y = lerp_angle(armsPivotRot.global_rotation.y, pivotRot.global_rotation.y, ARMS_ROT_SPEED*delta)
	armsPivotRot.global_rotation.x = lerp_angle(armsPivotRot.global_rotation.x, pivotRot.global_rotation.x, ARMS_ROT_SPEED*delta)
	pass


func onActiveUpdate(_value) -> void:
	arms.visible = _value
	armsPivotRot.global_rotation = pivotRot.global_rotation
	pass
