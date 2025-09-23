extends Node
class_name PoolManager

# cada idx desses arrays eh referente a um item
var pathInstances: Array[String] = []
var instancesCount: Array[int] = []
var instancesNames: Array[String] = []

# estrutura do dicionario: [name: String, array[PoolItem]]
var instancesDict: Dictionary = {}


func _init() -> void:
	Nodes.mainNode.call_deferred('add_child', self)
	pass


# MODELO DE READY A SER SEGUIDO:
#func _ready() -> void:
	#pathInstances = ["res://Components/VFX/BloodSplash.tscn"]
	#instancesCount = [10]
	#instancesNames = ['bloodSplash']
	#setupVisualInstances()
	#pass


func setupVisualInstances() -> void:
	for idx in range(pathInstances.size()):
		addInstances(pathInstances[idx], instancesCount[idx], instancesNames[idx])
	pass


func addInstances(_path: String, _count: int, _name: String) -> void:
	instancesDict[_name] = []
	
	for i in _count:
		var instance: PoolItem = load(_path).instantiate()
		instancesDict[_name].append(instance)
		self.call_deferred('add_child', instance)
	pass


func requestInstance(_name: String, _amount: int, _pos: Vector3) -> void:
	for i in _amount:
		var instance: PoolItem = getAvailableInstance(_name)
		instance.position = _pos
		instance.active()
	pass


func getAvailableInstance(_name: String) -> PoolItem:
	for i: PoolItem in instancesDict[_name]:
		if(not i.isBusy):
			return i
	
	var newInstance: PoolItem = instancesDict[_name][0].duplicate()
	instancesDict[_name].append(newInstance)
	return newInstance
