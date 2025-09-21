extends StateAction
class_name Sa_ChaseMovement

@export var character: CharacterBody3D


func perform() -> void:
	var direction = self.global_position.direction_to(Nodes.player.global_position)
	character.velocity = direction * 3.0
	character.move_and_slide()
	pass
