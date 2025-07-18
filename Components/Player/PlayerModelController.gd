extends Node
class_name PlayerModelController

@onready var playerState: PlayerState = Nodes.playerState
@export var selfMode: PlayerState.CAMERA_MODE
@export var pivotRot: Marker3D


func _ready() -> void:
	setActive(selfMode == playerState.currentCameraMode)
	playerState.connect("CameraModeChanged", onCameraModeChanged)
	playerState.connect("PlayerShot", onPlayerShot)
	pass


func onCameraModeChanged() -> void:
	setActive(selfMode == playerState.currentCameraMode)
	pass


func setActive(_value: bool) -> void:
	set_process(_value)
	set_physics_process(_value)
	self.visible = _value
	
	# precisa da verificao para o primeiro setActive (do ready)
	if(playerState.currentPivotRot):
		if(selfMode == playerState.CAMERA_MODE.FPS): pivotRot.global_rotation = playerState.currentPivotRot.global_rotation
		else: pivotRot.global_rotation.y = playerState.currentPivotRot.global_rotation.y
	pass


func onPlayerShot(_recoilStrength: float) -> void:
	pass
