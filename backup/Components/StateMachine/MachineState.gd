extends Node3D
class_name MachineState

@export var actions: Array[StateAction]

func perform() -> void:
	for i in actions:
		i.perform()
	pass
