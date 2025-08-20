extends Node


# lerp frame-rate independent
func betterLerpF(_currentValue:float, _targetValue:float, _lerpSpeed:float, _delta:float)->float:
	var t:float = 1.0 - exp(-_lerpSpeed * _delta)
	var newValue:float = lerp(_currentValue, _targetValue, t)
	return newValue


# lerp_angle frame-rate independent
func betterLerpAngleF(_currentValue:float, _targetValue:float, _lerpSpeed:float, _delta:float)->float:
	var t:float = 1.0 - exp(-_lerpSpeed * _delta)
	var newValue:float = lerp_angle(_currentValue, _targetValue, t)
	return newValue


func getValueFraction(maxValue: float, currentFactor: float, maxFactor: float) -> float:
	var multiplier: float = clamp(currentFactor / maxFactor, 0.0, 1.0)
	return maxValue * multiplier


# retorna 1.0 se o atual for igual à 0;
# retorna 0.0 se o atual for igual ao total;
# retorna 0.5 se o atual for igual ao total/2
func getRemaningFraction(_maxValue: float, _currentValue: float) -> float:
	var result = (_maxValue - _currentValue) / _maxValue
	return result


func getNodeVisualCopy(_node: Node3D, _visualLayer: int = 1) -> Node3D:
	var newNode: Node3D = _node.duplicate(0)
	var nodeList = getAllChildren(newNode)
	
	for c: Node in nodeList:
		if(c is VisualInstance3D): c.layers = _visualLayer
		if(
			c is RayCast3D or
			c is Light3D or
			c is AnimationPlayer or
			c.name == "Laser"
		):
			c.queue_free()
	
	return newNode


func getAllChildren(root: Node) -> Array[Node]:
	var out: Array[Node] = []
	for child in root.get_children(true):
		out.append(child)
		out += getAllChildren(child)
	return out
