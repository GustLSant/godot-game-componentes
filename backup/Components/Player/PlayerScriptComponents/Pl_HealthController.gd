extends Node
class_name Pl_HealthController

@onready var player: Player = Nodes.player


func _init() -> void:
	Nodes.player.connect("DamageTaken", onDamageTaken)
	pass


func onDamageTaken(_damage: int) -> void:
	var newHealthValue: int = player.health - _damage
	player.health = clamp(newHealthValue, 0, player.maxHealth)
	pass
