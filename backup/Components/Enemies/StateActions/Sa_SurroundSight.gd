extends StateAction
class_name Sa_SurroundSight


func perform() -> void:
	if(Nodes.player.global_position.distance_squared_to(self.global_position) <= 9.0):
		stateMachine.changeCurrentState($"../../ChasingState")
	pass
