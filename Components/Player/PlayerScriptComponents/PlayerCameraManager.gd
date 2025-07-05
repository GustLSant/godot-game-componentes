extends Node
class_name PlayerCameraManager

@export var playerState: PlayerState


func _input(_event: InputEvent) -> void:
	if(_event.is_action_pressed("ChangeCameraMode")):
		if(playerState.currentCameraMode == playerState.CAMERA_MODE.FPS): setCameraMode(playerState.CAMERA_MODE.TPS)
		else: setCameraMode(playerState.CAMERA_MODE.FPS)
	pass


func setCameraMode(_newCameraMode: PlayerState.CAMERA_MODE) -> void:
	playerState.currentCameraMode = _newCameraMode
	playerState.emit_signal("CameraModeChanged")
	pass
