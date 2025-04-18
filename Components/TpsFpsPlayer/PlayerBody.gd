class_name PlayerBody
extends Node3D

@onready var player:TpsFpsPlayer = $'..'
@onready var tpsCamera:TpsCamera = $'../TpsCamera'
@onready var fpsCamera:FpsCamera = $'../FpsCamera'
@onready var pivotRot:Marker3D = $PivotRotation

@export var pathAnimTree:NodePath
@onready var animTree:AnimationTree = get_node(pathAnimTree)

const BLEND_TRANSITION_SPEED_FACTOR:float = 10.0
var blendIdleToWalking:float = 0.0
var blendStrafes:float = 0.0

var delta:float = 0.01


func _ready()->void:
	pass


func _process(_delta:float)->void:
	delta = _delta
	handleRotation()
	handleAnimBlends()
	pass


func handleRotation()->void:
	if(player.isAiming):
		pivotRot.rotation.y = lerp_angle(pivotRot.rotation.y, tpsCamera.pivotRot.rotation.y, 25*delta)
	else:
		var targetBodyRotation:float = (tpsCamera.pivotRot.rotation.y * int(player.isMoving)) + (pivotRot.rotation.y * int(player.isStandingStill))
		pivotRot.rotation.y = lerp_angle(pivotRot.rotation.y, targetBodyRotation, 12*delta)
	pass


func handleAnimBlends()->void:
	blendIdleToWalking = lerp(
		blendIdleToWalking,
		int(player.isMoving)*1.0,
		BLEND_TRANSITION_SPEED_FACTOR * delta
	)
	
	var targetBlendStrafes:float = Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft")
	targetBlendStrafes *= int(player.isMoving)
	blendStrafes = lerp(blendStrafes, targetBlendStrafes, BLEND_TRANSITION_SPEED_FACTOR * delta)
	
	animTree["parameters/Blend_Idle_Walking/blend_amount"] = blendIdleToWalking
	animTree["parameters/Blend_Strafes/blend_amount"] = blendStrafes
	pass
