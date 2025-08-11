extends Node

@export var pivot: Node3D
@onready var player: Player = Nodes.player

@export var posRecoilCurve: Curve
@export var rotRecoilCurve: Curve
var tweenRecoil: Tween = null
var tweenPosRecoil: Tween = null
var tweenRotRecoil: Tween = null
var recoilCurveOffset: float = 0.0
var recoilRotZSide: float = 1.0

var delta: float = 0.016


func _process(_delta: float) -> void:
	delta = _delta
	handleRecoilEffect()
	pass


func handleRecoilEffect() -> void:
	var targetPosZ: float = posRecoilCurve.sample_baked(recoilCurveOffset) * 0.1                  * player.recoilPosZStrength
	var targetRotX: float = rotRecoilCurve.sample_baked(recoilCurveOffset) * 2.0                  * player.recoilRotXStrength
	var targetRotZ: float = rotRecoilCurve.sample_baked(recoilCurveOffset) * 1.0 * recoilRotZSide * player.recoilRotZStrength
	
	pivot.position.z =         Utils.betterLerpF(pivot.position.z,         targetPosZ, 45.0, delta)
	#pivot.rotation_degrees.x = Utils.betterLerpF(pivot.rotation_degrees.x, targetRotX, 45.0, delta)
	pivot.rotation_degrees.z = Utils.betterLerpF(pivot.rotation_degrees.z, targetRotZ, 45.0, delta)
	pass


func addRecoil() -> void:
	if(tweenRecoil):
		tweenRecoil.kill()
		tweenRecoil = get_tree().create_tween()
	else:
		tweenRecoil = get_tree().create_tween()
	
	recoilRotZSide = [-1, 1].pick_random()
	recoilCurveOffset = 1.0
	var tweenDuration: float = 0.4 / player.recoverFactor
	tweenRecoil.set_trans(Tween.TRANS_CUBIC)
	tweenRecoil.set_ease(Tween.EASE_OUT)
	tweenRecoil.tween_property(self, "recoilCurveOffset", 0.0, tweenDuration)
	pass
