extends Node
class_name PlayerCameraManager

@export var fpsRoot: PlayerCameraController
@onready var fpsPivotRot: Marker3D = fpsRoot.pivotRot
@export var tpsRoot: PlayerCameraController
@onready var tpsPivotRot: Marker3D = tpsRoot.pivotRot

enum CAMERA_MODE {FPS, TPS}
var currentCameraMode:CAMERA_MODE = CAMERA_MODE.FPS
var currentPivotRot: Marker3D = null


func _ready() -> void:
	setCameraMode(CAMERA_MODE.FPS)
	pass


func _input(_event: InputEvent) -> void:
	if(_event.is_action_pressed("ChangeCameraMode")):
		if(currentCameraMode == CAMERA_MODE.FPS): setCameraMode(CAMERA_MODE.TPS)
		else: setCameraMode(CAMERA_MODE.FPS)
	pass


func setCameraMode(_newCameraMode: CAMERA_MODE) -> void:
	currentCameraMode = _newCameraMode
	
	if(_newCameraMode == CAMERA_MODE.FPS):
		currentPivotRot = fpsPivotRot
		fpsRoot.call_deferred('setActive', true, tpsRoot.pivotRot.rotation)
		tpsRoot.call_deferred('setActive', false)
	else:
		currentPivotRot = tpsPivotRot
		fpsRoot.call_deferred('setActive', false)
		tpsRoot.call_deferred('setActive', true, fpsRoot.pivotRot.rotation)
	pass
