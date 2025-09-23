extends PoolManager
class_name GoreVfxManager


func _ready() -> void:
	pathInstances = ["res://Components/VFX/BloodSplash.tscn"]
	instancesCount = [10]
	instancesNames = ['bloodSplash']
	setupVisualInstances()
	pass
