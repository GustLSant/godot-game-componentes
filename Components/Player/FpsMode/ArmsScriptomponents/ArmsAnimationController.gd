extends Node
class_name ArmsAnimationController

@export var animTree: AnimationTree
@export var methodsAnimP: AnimationPlayer
@onready var player: Player = Nodes.player

var blendArmed: float = 0.0
var blendPosture: float = 0.0
var blendIdleToAiming: float = 0.0
var blendToSprinting: float = 0.0

var changingNextWeapon: PlayerWeapon = null

var delta: float = 0.016


func _init() -> void:
	Nodes.player.connect("PlayerShot", onPlayerShot)
	Nodes.player.connect("TryChangeWeapon", onTryChangeWeapon)
	pass


func _process(_delta: float) -> void:
	delta = _delta
	handleAnimations()
	handleInspect()
	pass


func handleAnimations() -> void:
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


func handleInspect() -> void:
	if(Input.is_action_just_pressed("InspectWeapon") and not player.isAiming and not player.isSprinting):
		animTree["parameters/OneShot_Inspect/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	pass


func abortInspectAnimation() -> void:
	animTree["parameters/OneShot_Inspect/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	pass


func onPlayerShot(_recoilStrength: float) -> void:
	abortInspectAnimation()
	pass


func onTryChangeWeapon(_newWeapon: PlayerWeapon) -> void:
	if(animTree["parameters/OneShot_ChangeWeapon/active"]): return
	changingNextWeapon = _newWeapon
	abortInspectAnimation()
	animTree["parameters/OneShot_ChangeWeapon/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	methodsAnimP.play("ChangeWeapon")
	pass


func onMiddleOfChangeWeaponAnimation() -> void:
	Nodes.player.emit_signal("ChangeWeapon", changingNextWeapon)
	pass
