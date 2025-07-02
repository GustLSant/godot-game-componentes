extends Node
class_name PlayerCameraController

const CAMERA_X_RANGE = 75.0
@export var pivotRot:Marker3D
@export var camera: Camera3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass


func _input(_event: InputEvent) -> void:
	if(_event is InputEventMouseMotion):
		pivotRot.rotation_degrees.y -= _event.relative.x * 0.3
		pivotRot.rotation_degrees.x -= _event.relative.y * 0.3
		pivotRot.rotation_degrees.x = clamp(pivotRot.rotation_degrees.x, -CAMERA_X_RANGE, CAMERA_X_RANGE)
	pass


func setActive(_value, _otherCameraRotation: Vector3 = Vector3.ZERO) -> void:
	self.set_process(_value)
	self.set_physics_process(_value)
	self.set_process_input(_value)
	camera.current = _value
	
	if(_value):
		pivotRot.rotation = _otherCameraRotation
	
	onActiveUpdate(_value)
	pass


# evento para ser sobrescrito
func onActiveUpdate(_value) -> void:
	pass
