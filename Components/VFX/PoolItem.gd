extends Node3D
class_name PoolItem

var isBusy: bool = false
@export var animPlayer: AnimationPlayer


func _ready() -> void:
	animPlayer.connect('animation_finished', onAnimationFinished)
	pass


func active() -> void:
	if(isBusy): return
	activeOperation()
	isBusy = true
	pass


# funcao a ser sobrescrita
func activeOperation() -> void:
	pass


func onAnimationFinished(_animName: String) -> void:
	isBusy = false
	pass
