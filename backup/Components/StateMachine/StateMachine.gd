extends Node3D
class_name StateMachine

@export var initialState: MachineState
@onready var currentState: MachineState = initialState

var pdelta: float = 0.016


func _physics_process(_delta: float) -> void:
	pdelta = _delta
	currentState.perform()
	pass


func changeCurrentState(_newState: MachineState) -> void:
	currentState = _newState
	pass
