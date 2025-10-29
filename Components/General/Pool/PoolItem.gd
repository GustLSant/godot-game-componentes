extends Node3D
class_name PoolItem

var isBusy: bool = false
@export var animPlayer: AnimationPlayer


func _ready() -> void:
	animPlayer.connect('animation_finished', onAnimationFinished)
	pass


# can override
func active(_extraValues: Array) -> void:
	if(isBusy): return
	self.call_deferred('playEffect', _extraValues)
	isBusy = true
	pass


# can override
func playEffect(_extraValues: Array) -> void:
	var _pos: Vector3 = _extraValues[0]
	
	position = _pos
	
	animPlayer.play('Effect')
	pass

# can override
func endEffect() -> void:
	pass


func onAnimationFinished(_animName: String) -> void:
	isBusy = false
	endEffect()
	pass
