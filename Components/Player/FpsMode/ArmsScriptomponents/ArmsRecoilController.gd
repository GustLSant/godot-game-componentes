extends Node
class_name ArmsRecoilController

@export var pivot: Node3D
@onready var player: Player = Nodes.player

const TWEEN_ATTACK_DURATION: float = 0.05
const TWEEN_RECOVER_DURATION: float = 0.2
var tweenRecoil: Tween = null

const BASE_RECOIL_STRENGTH_POS_Z: float = 0.125
const BASE_RECOIL_STRENGTH_POS_Y: float = 0.125
const BASE_RECOIL_STRENGTH_ROT_X: float = 3.0
const BASE_RECOIL_STRENGTH_ROT_Z: float = 1.25
var recoilFactor: float = 0.0
var recoilRotZSide: float = 1.0

var delta: float = 0.016


func _init() -> void:
	Nodes.player.connect("PlayerShot", onPlayerShot)
	pass


func _process(_delta: float) -> void:
	delta = _delta
	handleRecoilEffect()
	pass


func handleRecoilEffect() -> void:
	pivot.position.z =         BASE_RECOIL_STRENGTH_POS_Z * player.recoilPosZStrength * recoilFactor
	pivot.position.y =         BASE_RECOIL_STRENGTH_POS_Y * player.recoilPosYStrength * recoilFactor
	pivot.rotation_degrees.x = BASE_RECOIL_STRENGTH_ROT_X * player.recoilRotXStrength * recoilFactor
	
	var targetRotZ: float =    BASE_RECOIL_STRENGTH_ROT_Z * player.recoilRotZStrength * recoilFactor * recoilRotZSide
	pivot.rotation_degrees.z = lerp(pivot.rotation_degrees.z, targetRotZ, 16.0 * delta)
	pass


func addRecoil() -> void:
	recoilRotZSide = [-1.0, 1.0].pick_random()
	playeRecoilAttackEffect()
	pass


func playeRecoilAttackEffect() -> void:
	tweenRecoil = getRestartedTween(tweenRecoil)
	
	var durationFactor: float = Utils.getRemaningFraction(1.0, recoilFactor)
	tweenRecoil.set_trans(Tween.TRANS_CUBIC)
	tweenRecoil.set_ease(Tween.EASE_OUT)
	
	tweenRecoil.tween_property           (self, "recoilFactor", 1.0, TWEEN_ATTACK_DURATION * durationFactor)
	tweenRecoil.parallel().tween_property(self, "recoilFactor", 1.0, TWEEN_ATTACK_DURATION * durationFactor)
	
	tweenRecoil.connect("step_finished", onTweenPosRecoilStepFinished)
	pass


func playRecoilRecoverEffect() -> void:
	tweenRecoil = getRestartedTween(tweenRecoil)
	
	tweenRecoil.set_trans(Tween.TRANS_CUBIC)
	tweenRecoil.set_ease(Tween.EASE_OUT)
	
	tweenRecoil.tween_property           (self, "recoilFactor", 0.0, TWEEN_RECOVER_DURATION * player.recoverFactor)
	tweenRecoil.parallel().tween_property(self, "recoilFactor", 0.0, TWEEN_RECOVER_DURATION * player.recoverFactor)
	pass


func onTweenPosRecoilStepFinished(_idx: int) -> void:
	if(recoilFactor == 1):
		playRecoilRecoverEffect()
	pass

func onTweenRotRecoilStepFinished(_idx: int) -> void:
	if(recoilFactor == 1):
		playRecoilRecoverEffect()
	pass


func getRestartedTween(_tween: Tween) -> Tween:
	if(_tween):
		_tween.kill()
	return get_tree().create_tween()


func onPlayerShot(_recoilStrength: float) -> void:
	addRecoil()
	pass
