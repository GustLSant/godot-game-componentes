extends Node
class_name PoolManager

var instancePath: String
var instances: Array[PoolItem] = []


func _init(_instancePath: String, _initialAmount: int = 100) -> void:
	instancePath = _instancePath
	Nodes.mainNode.call_deferred('add_child', self)
	self.call_deferred('setupInstances', _initialAmount)
	pass


func setupInstances(_initialAmount: int) -> void:
	for idx in range(_initialAmount):
		var instance: PoolItem = load(instancePath).instantiate()
		instances.append(instance)
		self.call_deferred('add_child', instance)
	pass


func requestInstance(_amount: int, _extraValues: Array = []) -> void:
	for i in _amount:
		var instance: PoolItem = getAvailableInstance()
		instance.active(_extraValues)
	pass


func getAvailableInstance() -> PoolItem:
	for i: PoolItem in instances:
		if(not i.isBusy):
			return i
	
	var newInstance: PoolItem = load(instancePath).instantiate()
	instances.append(newInstance)
	self.call_deferred('add_child', newInstance)
	return newInstance
