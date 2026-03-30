class_name FpsCameraRotController
extends Node

var lastMouseMotion: Vector2 = Vector2.ZERO

const MAX_LOOK_ANGLE: float = 80.0
const MIN_LOOK_ANGLE: float = -80.0


func run(_pivotRot: Node3D, _xCamSensi: float, _yCamSensi: float) -> void:
	handleRotation(_pivotRot, _xCamSensi, _yCamSensi)
	pass


func _input(event):
	if event is InputEventMouseMotion:
		lastMouseMotion.x = event.relative.x
		lastMouseMotion.y = event.relative.y
	return


func handleRotation(_pivotRot: Node3D, _xCamSensi: float, _yCamSensi: float) -> void:
	_pivotRot.rotation_degrees.x -= lastMouseMotion.y * _yCamSensi
	_pivotRot.rotation_degrees.y -= lastMouseMotion.x * _xCamSensi
	lastMouseMotion = Vector2.ZERO
	
	_pivotRot.rotation_degrees.x = clamp(_pivotRot.rotation_degrees.x, MIN_LOOK_ANGLE, MAX_LOOK_ANGLE)
	pass
