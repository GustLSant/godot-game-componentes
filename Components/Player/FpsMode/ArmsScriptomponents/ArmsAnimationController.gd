extends Node
class_name ArmsAnimationController

@export var animTree: AnimationTree
@onready var playerState: PlayerState = Nodes.playerState

var blendPosture: float = 0.0
var blendIdleToAiming: float = 0.0
var blendToSprinting: float = 0.0

var delta: float = 0.016


func _process(_delta: float) -> void:
	delta = _delta
	handleAnimations()
	handleInspect()
	pass


func handleAnimations() -> void:
	blendPosture = lerp(blendPosture, float(playerState.currentWeapon and playerState.currentWeapon.ammoId > 0), 10.0 * delta)
	
	blendIdleToAiming = lerp(blendIdleToAiming, float(playerState.isAiming),    10.0 * delta)
	blendToSprinting =  lerp(blendToSprinting,  float(playerState.isSprinting), 10.0 * delta)
	
	animTree["parameters/Blend_Posture_1/blend_amount"]  = blendPosture
	animTree["parameters/Blend_Posture_2/blend_amount"]  = blendPosture
	animTree["parameters/Blend_Posture_3/blend_amount"]  = blendPosture
	animTree["parameters/Blend_IdleAiming/blend_amount"] = blendIdleToAiming
	animTree["parameters/Blend_Sprinting/blend_amount"]  = blendToSprinting
	pass


func handleInspect() -> void:
	if(Input.is_action_just_pressed("Test")):
		animTree["parameters/OneShot_ShortInspect/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	pass
