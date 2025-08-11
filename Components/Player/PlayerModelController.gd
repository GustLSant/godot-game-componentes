extends Node
class_name PlayerModelController

@onready var player: Player = Nodes.player
@export var selfMode: Player.CAMERA_MODE
@export var pivotRot: Marker3D


func _init() -> void:
	Nodes.player.connect("CameraModeChanged", onCameraModeChanged)
	Nodes.player.connect("PlayerShot", onPlayerShot)
	pass


func _ready() -> void:
	setActive(selfMode == player.currentCameraMode)
	pass


func onCameraModeChanged() -> void:
	setActive(selfMode == player.currentCameraMode)
	pass


func setActive(_value: bool) -> void:
	set_process(_value)
	set_physics_process(_value)
	self.visible = _value
	
	# precisa da verificao para o primeiro setActive (do ready)
	if(player.currentPivotRot):
		if(selfMode == player.CAMERA_MODE.FPS): pivotRot.global_rotation = player.currentPivotRot.global_rotation
		else: pivotRot.global_rotation.y = player.currentPivotRot.global_rotation.y
	pass


func onPlayerShot(_recoilStrength: float) -> void:
	pass
