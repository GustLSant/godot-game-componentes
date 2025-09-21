extends Node3D
class_name StateMachine

@export var initialState: MachineState
@export var states: Array[MachineState]
@onready var currentState: MachineState = initialState

var pdelta: float = 0.016

# external variables
@export var healthController: HealthController


func _ready() -> void:
	healthController.connect('Died', onDied)
	pass


func _physics_process(_delta: float) -> void:
	pdelta = _delta
	currentState.perform()
	pass


func changeCurrentState(_newState: MachineState) -> void:
	currentState = _newState
	pass


func onDied() -> void:
	print('enemy Died!!!!!!')
	var deadState: MachineState = $DeadState
	changeCurrentState(deadState)
	pass
