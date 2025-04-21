class_name PlayerBody
extends Node3D

@onready var player:TpsFpsPlayer = $'..'
@onready var tpsCamera:TpsCamera = $'../TpsCamera'
@onready var fpsCamera:FpsCamera = $'../FpsCamera'
@onready var pivotRot:Marker3D = $PivotRotation
@onready var pivotRefRot:Marker3D = $PivotRefRot
@onready var skeleton:Skeleton3D = $PivotRotation/blockbench_export/origin/Skeleton3D

@export var pathAnimTree:NodePath
@onready var animTree:AnimationTree = get_node(pathAnimTree)

const BLEND_TRANSITION_SPEED_FACTOR:float = 10.0
var blendIdleToWalking:float = 0.0
var blendWalkingToRunning:float = 0.0
var blendAiming:float = 0.0

# Recoil
@export var curveRecoil:Curve
@onready var pivotRecoilBoneIdx:int = skeleton.find_bone("pivot_recoil")
const RECOIL_STRENGTH:float = 0.1
var recoilCurveOffset:float = 0.0


var delta:float = 0.01


func _ready()->void:
	pass


func _process(_delta:float)->void:
	delta = _delta
	handleRotation()
	handleRecoilEffect()
	handleAnimBlends()
	if(Input.is_action_just_pressed('Shoot')): addRecoil()
	pass


func handleRotation()->void:
	if(player.isAiming):
		pivotRot.rotation.y = Utils.betterLerpAngleF(pivotRot.rotation.y, tpsCamera.pivotRot.rotation.y, 25, delta)
	else:
		#rotacao para o mesmo sentido da camera tps
		#var targetBodyRotationY:float = (tpsCamera.pivotRot.rotation.y * int(player.isMoving)) + (pivotRot.rotation.y * int(player.isStandingStill))
		if(player.isMoving):
			pivotRefRot.look_at(player.global_position + player.vecMovement.normalized())
		var targetBodyRotationY:float = (
			pivotRot.rotation.y * int(player.isStandingStill) +
			pivotRefRot.rotation.y * int(player.isMoving)
		)
		pivotRot.rotation.y = lerp_angle(pivotRot.rotation.y, targetBodyRotationY, 8*delta)
	pass


func handleRecoilEffect()->void:
	const DECREASE_FACTOR:float = 12.0
	recoilCurveOffset = lerp(recoilCurveOffset, 0.0, DECREASE_FACTOR*delta)
	pass

func addRecoil()->void:
	recoilCurveOffset = 1.0
	animTree.set("parameters/ShotRecoil/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	pass


func handleAnimBlends()->void:
	blendIdleToWalking = lerp(
		blendIdleToWalking,
		float(int(player.isMoving)),
		BLEND_TRANSITION_SPEED_FACTOR * delta
	)
	
	blendAiming = lerp(blendAiming, float(int(player.isAiming)), BLEND_TRANSITION_SPEED_FACTOR*delta)
	blendWalkingToRunning = lerp(blendWalkingToRunning, float(int(player.isSprinting)), BLEND_TRANSITION_SPEED_FACTOR*delta)
	
	animTree["parameters/TS_Walking/scale"] = 1.0 - (0.5 * int(player.isAiming))
	animTree["parameters/Blend_AimingAngles/blend_amount"] = (tpsCamera.pivotRot.rotation_degrees.x / 60.0) / 2.0 + 0.5
	
	animTree["parameters/Blend_Idle_Walking/blend_amount"] = blendIdleToWalking
	animTree["parameters/Blend_Aiming/blend_amount"] = blendAiming
	animTree["parameters/Blend_Walking_Running/blend_amount"] = blendWalkingToRunning
	pass
