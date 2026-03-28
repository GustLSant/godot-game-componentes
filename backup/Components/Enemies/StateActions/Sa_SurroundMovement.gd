extends StateAction
class_name Sa_SurroundMovement

@export var character: CharacterBody3D
var moveVector: Vector3 = Vector3.ZERO
var timer: float = 0.0


func _ready() -> void:
	timer = 2.0
	pass


func perform() -> void:
	character.velocity = moveVector * 2.0
	character.move_and_slide()
	
	timer -= 1 * stateMachine.pdelta
	if(timer <= 0.0):
		moveVector.x = randf_range(-1.0, 1.0)
		moveVector.z = randf_range(-1.0, 1.0)
		timer = randf_range(2.0, 3.0)
	pass
