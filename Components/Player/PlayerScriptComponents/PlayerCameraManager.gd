extends Node
class_name PlayerCameraManager

@onready var player: Player = Nodes.player


func _input(_event: InputEvent) -> void:
	if(_event.is_action_pressed("ChangeCameraMode")):
		if(player.currentCameraMode == player.CAMERA_MODE.FPS): setCameraMode(player.CAMERA_MODE.TPS)
		else: setCameraMode(player.CAMERA_MODE.FPS)
	pass


func setCameraMode(_newCameraMode: Player.CAMERA_MODE) -> void:
	player.currentCameraMode = _newCameraMode
	player.emit_signal("CameraModeChanged")
	pass
