extends StateAction
class_name Sa_LoseSightDistance

@export var targetState: MachineState


func perform() -> void:
	if(Nodes.player.global_position.distance_squared_to(self.global_position) >= 100.0):
		stateMachine.changeCurrentState(targetState)
	pass
