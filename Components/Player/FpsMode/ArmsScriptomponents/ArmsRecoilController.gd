extends Node
class_name ArmsRecoilController

@export var pivot: Node3D
@onready var playerState: PlayerState = Nodes.playerState

const TWEEN_ATTACK_DURATION: float = 0.05
const TWEEN_RECOVER_DURATION: float = 0.2
var tweenPosRecoil: Tween = null
var tweenRotRecoil: Tween = null

const BASE_RECOIL_POS_Z: float = 0.2
const BASE_RECOIL_ROT_X: float = 1.0
var recoilPosFactor: float = 0.0
var recoilRotFactor: float = 0.0

var delta: float = 0.016


func _process(_delta: float) -> void:
	delta = _delta
	handleRecoilEffect()
	pass


func handleRecoilEffect() -> void:
	pivot.position.z =         BASE_RECOIL_POS_Z * playerState.recoilPosZStrength * recoilPosFactor
	pivot.rotation_degrees.x = BASE_RECOIL_ROT_X * playerState.recoilRotXStrength * recoilRotFactor
	pass


func addRecoil() -> void:
	playeRecoilPosAttack()
	playeRecoilRotAttack()
	pass


func playeRecoilPosAttack() -> void:
	tweenPosRecoil = getRestartedTween(tweenPosRecoil)
	
	var durationFactor: float = Utils.getRemaningFraction(1.0, recoilPosFactor)
	tweenPosRecoil.set_trans(Tween.TRANS_CUBIC)
	tweenPosRecoil.set_ease(Tween.EASE_OUT)
	
	tweenPosRecoil.tween_property(self, "recoilPosFactor", 1.0, TWEEN_ATTACK_DURATION * durationFactor)
	tweenPosRecoil.connect("step_finished", onTweenPosRecoilStepFinished)
	pass

func playRecoilPosRecover() -> void:
	tweenPosRecoil = getRestartedTween(tweenPosRecoil)
	
	tweenPosRecoil.set_trans(Tween.TRANS_CUBIC)
	tweenPosRecoil.set_ease(Tween.EASE_OUT)
	
	tweenPosRecoil.tween_property(self, "recoilPosFactor", 0.0, TWEEN_RECOVER_DURATION)
	pass


func playeRecoilRotAttack() -> void:
	tweenRotRecoil = getRestartedTween(tweenRotRecoil)
	
	var durationFactor: float = Utils.getRemaningFraction(1.0, recoilRotFactor)
	tweenRotRecoil.set_trans(Tween.TRANS_LINEAR)
	tweenRotRecoil.set_ease(Tween.EASE_OUT)
	
	tweenRotRecoil.tween_property(self, "recoilRotFactor", 1.0, TWEEN_ATTACK_DURATION * durationFactor)
	tweenRotRecoil.connect("step_finished", onTweenRotRecoilStepFinished)
	pass

func playRecoilRotRecover() -> void:
	tweenRotRecoil = getRestartedTween(tweenRotRecoil)
	
	tweenRotRecoil.set_trans(Tween.TRANS_LINEAR)
	tweenRotRecoil.set_ease(Tween.EASE_OUT)
	
	tweenRotRecoil.tween_property(self, "recoilRotFactor", 0.0, TWEEN_RECOVER_DURATION)
	pass


func onTweenPosRecoilStepFinished(_idx: int) -> void:
	if(recoilPosFactor == 1):
		playRecoilPosRecover()
	pass

func onTweenRotRecoilStepFinished(_idx: int) -> void:
	if(recoilRotFactor == 1):
		playRecoilRotRecover()
	pass


func getRestartedTween(_tween: Tween) -> Tween:
	if(_tween):
		_tween.kill()
	return get_tree().create_tween()
