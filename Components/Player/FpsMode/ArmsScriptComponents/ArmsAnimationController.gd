extends Node
class_name ArmsAnimationController

@export var animTree: AnimationTree
@export var methodsAnimP: AnimationPlayer
@onready var player: Player = Nodes.player

var blendArmed: float = 0.0
var blendPosture: float = 0.0
var blendIdleToAiming: float = 0.0
var blendToSprinting: float = 0.0

var tweenChangeWeapon: Tween
var changeWeaponFactor: float = 0.0

var delta: float = 0.016


func _init() -> void:
	Nodes.player.connect("RequestInteractAnim", onRequestInteractAnim)
	Nodes.player.connect("PlayerShot", onPlayerShot)
	pass


func _process(_delta: float) -> void:
	delta = _delta
	handleBlendAnimations()
	handleInspectAnimation()
	handleChangeAnimation()
	pass


func handleBlendAnimations() -> void:
	blendArmed        = lerp(blendArmed,        float(is_instance_valid(player.currentWeapon)), 10.0 * delta)
	blendPosture      = lerp(blendPosture,      float(player.currentWeapon and player.currentWeapon.ammoId > 0), 10.0 * delta)
	blendIdleToAiming = lerp(blendIdleToAiming, float(player.isAiming),    10.0 * delta)
	blendToSprinting  = lerp(blendToSprinting,  float(player.isSprinting), 10.0 * delta)
	
	animTree["parameters/Blend_Armed/blend_amount"] = blendArmed
	
	animTree["parameters/Blend_Posture_1/blend_amount"]  = blendPosture
	animTree["parameters/Blend_Posture_2/blend_amount"]  = blendPosture
	animTree["parameters/Blend_Posture_3/blend_amount"]  = blendPosture
	animTree["parameters/Blend_Posture_4/blend_amount"]  = blendPosture
	animTree["parameters/Blend_IdleAiming/blend_amount"] = blendIdleToAiming
	animTree["parameters/Blend_Sprinting/blend_amount"]  = blendToSprinting
	pass


func handleInspectAnimation() -> void:
	if(Input.is_action_just_pressed("InspectWeapon") and not player.isAiming and not player.isSprinting and not animTree["parameters/OneShot_Inspect/active"]):
		animTree["parameters/OneShot_Inspect/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	pass


func handleChangeAnimation() -> void:
	animTree["parameters/Add_ChangeWeapon/add_amount"] = changeWeaponFactor
	pass


func abortInspectAnimation() -> void:
	animTree["parameters/OneShot_Inspect/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	pass


func onRequestInteractAnim(_callback: Callable) -> void:
	if(changeWeaponFactor > 0.0): return
	
	if(tweenChangeWeapon): tweenChangeWeapon.kill()
	tweenChangeWeapon = get_tree().create_tween()
	
	tweenChangeWeapon.tween_property(self, 'changeWeaponFactor', 1.0, 0.25)
	tweenChangeWeapon.tween_callback(_callback)
	tweenChangeWeapon.tween_property(self, 'changeWeaponFactor', 0.0, 0.25)
	tweenChangeWeapon.play()
	pass


func onPlayerShot(_recoilStrength: float) -> void:
	abortInspectAnimation()
	pass
