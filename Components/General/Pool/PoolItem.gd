extends Node3D
class_name PoolItem

var isBusy: bool = false
@export var animPlayer: AnimationPlayer


func _ready() -> void:
	animPlayer.connect('animation_finished', onAnimationFinished)
	pass


func active(_pos: Vector3, _rot: Vector3, _extraValues: Array[float]) -> void:
	if(isBusy): return
	position = _pos
	rotation_degrees = _rot
	self.call_deferred('playEffect', _extraValues)
	isBusy = true
	pass


# funcao a ser sobrescrita
func playEffect(_extraValues: Array[float]) -> void:
	animPlayer.play('Effect')
	pass


func onAnimationFinished(_animName: String) -> void:
	isBusy = false
	pass
