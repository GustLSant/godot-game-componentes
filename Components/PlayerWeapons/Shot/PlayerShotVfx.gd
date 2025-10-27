extends PoolItem
class_name PlayerShotVfx

@export var trailMesh: Node3D

func playEffect(_extraValues: Array[float]) -> void:
	animPlayer.play('Effect')
	$MuzzleFlash.rotation_degrees.z = randf_range(-90.0, 90.0)
	trailMesh.scale.z = _extraValues[0]
	pass
