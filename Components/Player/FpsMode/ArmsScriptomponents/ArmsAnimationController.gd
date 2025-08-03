extends Node
class_name ArmsAnimationController

@export var animTree: AnimationTree
@onready var playerState: PlayerState = Nodes.playerState

var blendToLong: float = 0.0
var blendToSprinting: float = 0.0

var delta: float = 0.016


func _process(_delta: float) -> void:
	delta = _delta
	handleAnimations()
	pass


func handleAnimations() -> void:
	blendToLong = float(playerState.currentWeapon and playerState.currentWeapon.ammoId > 0)
	blendToSprinting = lerp(blendToSprinting, float(playerState.isSprinting), 10.0 * delta)
	
	animTree["parameters/Blend_PostureIdle/blend_amount"] = blendToLong
	animTree["parameters/Blend_PostureSprinting/blend_amount"] = blendToLong
	animTree["parameters/Blend_Sprinting/blend_amount"] = blendToSprinting
	pass
