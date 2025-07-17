extends Node
class_name PlayerModelController

@export var selfMode: PlayerState.CAMERA_MODE
@export var pivotRot: Marker3D


func _ready() -> void:
	setActive(selfMode == PlayerState.currentCameraMode)
	PlayerState.connect("CameraModeChanged", onCameraModeChanged)
	PlayerState.connect("PlayerShot", onPlayerShot)
	pass


func onCameraModeChanged() -> void:
	setActive(selfMode == PlayerState.currentCameraMode)
	pass


func setActive(_value: bool) -> void:
	set_process(_value)
	set_physics_process(_value)
	self.visible = _value
	
	# precisa da verificao para o primeiro setActive (do ready)
	if(PlayerState.currentPivotRot):
		if(selfMode == PlayerState.CAMERA_MODE.FPS): pivotRot.global_rotation = PlayerState.currentPivotRot.global_rotation
		else: pivotRot.global_rotation.y = PlayerState.currentPivotRot.global_rotation.y
	pass


func onPlayerShot(_recoilStrength: float) -> void:
	pass
