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
