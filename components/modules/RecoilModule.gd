class_name RecoilModule
extends Node

const BASE_RECOIL_STRENGTH_POS_Z: float = 0.25
const BASE_RECOIL_STRENGTH_ROT_X: float = 3.0
const BASE_RECOIL_STRENGTH_ROT_Z: float = 1.25

const TWEEN_ATTACK_DURATION: float = 0.05
const TWEEN_DECAY_DURATION: float = 0.2

const LERP_FACTOR: float = 16.0

var _recoilRotZSide: int = 0
var _recoilFactor: float = 0.0
var _tweenRecoil: Tween = null

var posOffset: Vector3 = Vector3.ZERO
var rotOffset: Vector3 = Vector3.ZERO


func run(posZStrength: float, rotXStrength: float, rotZStrength: float, delta: float) -> void:
	posOffset.z = BASE_RECOIL_STRENGTH_POS_Z * posZStrength * _recoilFactor
	
	rotOffset.x = BASE_RECOIL_STRENGTH_ROT_X * rotXStrength * _recoilFactor
	rotOffset.z = lerp(
		rotOffset.z,
		BASE_RECOIL_STRENGTH_ROT_Z * rotZStrength * _recoilFactor * _recoilRotZSide,
		LERP_FACTOR * delta
	)
	pass


func addRecoil() -> void:
	_recoilRotZSide = [-1.0, 1.0].pick_random()
	_playRecoilEffect()
	pass


func _playRecoilEffect() -> void:
	_tweenRecoil = _getRestartedTween()
	
	var _durationFactor: float = Utils.getRemaningFraction(1.0, _recoilFactor)
	_tweenRecoil.set_trans(Tween.TRANS_CUBIC)
	_tweenRecoil.set_ease(Tween.EASE_OUT)
	
	_tweenRecoil.tween_property(self, "_recoilFactor", 1.0, TWEEN_ATTACK_DURATION * _durationFactor)
	_tweenRecoil.tween_property(self, "_recoilFactor", 0.0, TWEEN_DECAY_DURATION * _durationFactor)
	
	pass


func _getRestartedTween() -> Tween:
	if(_tweenRecoil):
		_tweenRecoil.kill()
	return get_tree().create_tween()
