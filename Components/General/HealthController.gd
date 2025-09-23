extends Node
class_name HealthController

@export var maxLife: float = 100.0
@onready var life: float = maxLife

signal DamageTaken(_from: Vector3, _impactStrength: float)
signal Died()


func takeDamage(_damage: float, _pos:Vector3 = Vector3.ZERO, _from: Vector3 = Vector3.ZERO, _impactStrength: float = 0.0):
	Nodes.goreVfxManager.requestInstance('bloodSplash', 2, _pos)
	
	if(life <= 0.0): return
	
	life -= _damage
	self.emit_signal('DamageTaken', _from, _impactStrength)
	if(life <= 0.0): emit_signal('Died')
	pass
