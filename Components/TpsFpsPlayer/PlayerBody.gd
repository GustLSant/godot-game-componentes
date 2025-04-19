class_name PlayerBody
extends Node3D

@onready var player:TpsFpsPlayer = $'..'
@onready var tpsCamera:TpsCamera = $'../TpsCamera'
@onready var fpsCamera:FpsCamera = $'../FpsCamera'
@onready var pivotRot:Marker3D = $PivotRotation
@onready var pivotRefRot:Marker3D = $PivotRefRot

@export var pathAnimTree:NodePath
@onready var animTree:AnimationTree = get_node(pathAnimTree)

const BLEND_TRANSITION_SPEED_FACTOR:float = 10.0
var blendIdleToWalking:float = 0.0
var blendAiming:float = 0.0

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
		#rotacao para o mesmo sentido da camera tps
		#var targetBodyRotationY:float = (tpsCamera.pivotRot.rotation.y * int(player.isMoving)) + (pivotRot.rotation.y * int(player.isStandingStill))
		if(player.isMoving):
			pivotRefRot.look_at(player.global_position + player.vecMovement.normalized())
			$MeshInstance3D.global_position = player.global_position + player.vecMovement.normalized()
		var targetBodyRotationY:float = (
			pivotRot.rotation.y * int(player.isStandingStill) +
			pivotRefRot.rotation.y * int(player.isMoving)
		)
		pivotRot.rotation.y = lerp_angle(pivotRot.rotation.y, targetBodyRotationY, 8*delta)
	pass


func handleAnimBlends()->void:
	blendIdleToWalking = lerp(
		blendIdleToWalking,
		float(int(player.isMoving)),
		BLEND_TRANSITION_SPEED_FACTOR * delta
	)
	
	blendAiming = lerp(blendAiming, float(int(player.isAiming)), BLEND_TRANSITION_SPEED_FACTOR*delta)
	
	animTree["parameters/Blend_AimingAngles/blend_amount"] = (tpsCamera.pivotRot.rotation_degrees.x / 60.0) / 2.0 + 0.5
	
	animTree["parameters/Blend_Idle_Walking/blend_amount"] = blendIdleToWalking
	animTree["parameters/Blend_Aiming/blend_amount"] = blendAiming
	pass
