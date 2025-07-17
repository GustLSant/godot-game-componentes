extends Node
class_name PlayerCameraManager


func _input(_event: InputEvent) -> void:
	if(_event.is_action_pressed("ChangeCameraMode")):
		if(PlayerState.currentCameraMode == PlayerState.CAMERA_MODE.FPS): setCameraMode(PlayerState.CAMERA_MODE.TPS)
		else: setCameraMode(PlayerState.CAMERA_MODE.FPS)
	pass


func setCameraMode(_newCameraMode: PlayerState.CAMERA_MODE) -> void:
	PlayerState.currentCameraMode = _newCameraMode
	PlayerState.emit_signal("CameraModeChanged")
	pass
