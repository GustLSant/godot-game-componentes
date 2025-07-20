extends Node
class_name PlayerHealthController

@onready var playerState: PlayerState = Nodes.playerState


func _init() -> void:
	Nodes.playerState.connect("DamageTaken", onDamageTaken)
	pass


func onDamageTaken(_damage: int) -> void:
	var newHealthValue: int = playerState.health - _damage
	playerState.health = clamp(newHealthValue, 0, playerState.maxHealth)
	pass
