extends StateMachine
class_name En_StateMachine

# external variables
@export var healthController: HealthController


func _ready() -> void:
	healthController.connect('Died', onDied)
	pass


func onDied() -> void:
	print('enemy Died!!!!!!')
	var deadState: MachineState = $DeadState
	changeCurrentState(deadState)
	pass
