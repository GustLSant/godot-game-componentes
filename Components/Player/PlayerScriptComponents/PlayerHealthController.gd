extends Node
class_name PlayerHealthController


func _ready() -> void:
	PlayerState.connect("DamageTaken", onDamageTaken)
	pass


func onDamageTaken(_damage: int) -> void:
	var newHealthValue: int = PlayerState.health - _damage
	PlayerState.health = clamp(newHealthValue, 0, PlayerState.maxHealth)
	pass
