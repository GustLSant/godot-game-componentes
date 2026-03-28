extends PoolItem
class_name PlayerShotVfx

@export var trailMesh: Node3D
@export var weaponAttachedNodes: Node3D
@export var muzzleFlash: Node3D
var weaponBarrel: Node3D = self


func _ready() -> void:
	super._ready()
	set_process(false)
	pass


func playEffect(_extraValues: Array) -> void:
	animPlayer.play('Effect')
	
	trailMesh.scale.z = _extraValues[0]
	muzzleFlash.rotation_degrees.z = randf_range(-90.0, 90.0)
	
	weaponBarrel = _extraValues[1]
	set_process(true)
	pass


func _process(_delta: float) -> void:
	weaponAttachedNodes.global_transform = weaponBarrel.global_transform
	pass


func endEffect() -> void:
	set_process(false)
	pass
