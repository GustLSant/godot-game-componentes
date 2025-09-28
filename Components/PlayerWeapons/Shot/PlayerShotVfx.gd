extends PoolItem
class_name PlayerShotVfx

@export var trailMesh: Node3D

func playEffect(_extraValues: Array[float]) -> void:
	animPlayer.play('Effect')
	trailMesh.scale.z = _extraValues[0]
	pass
