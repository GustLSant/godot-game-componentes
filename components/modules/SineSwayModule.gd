class_name SineSwayModule
extends Node

const FREQUENCY_MULTIPLIER: float = 0.01

const X_AMPLITUDE_MULTIPLIER: float = 0.0375
const Y_AMPLITUDE_MULTIPLIER: float = 0.075

const LERP_FACTOR: float = 12.0

var _rawPosOffset: Vector3 = Vector3.ZERO
var posOffset: Vector3 = Vector3.ZERO


func run(frequency: float, amplitude: float, delta: float) -> void:
	_rawPosOffset = Vector3(
		sin(Time.get_ticks_msec() * frequency * FREQUENCY_MULTIPLIER * 0.5) * amplitude * X_AMPLITUDE_MULTIPLIER,
		sin(Time.get_ticks_msec() * frequency * FREQUENCY_MULTIPLIER)       * amplitude * Y_AMPLITUDE_MULTIPLIER,
		0.0
	)
	
	posOffset = lerp(
		posOffset,
		_rawPosOffset,
		LERP_FACTOR * delta
	)
	pass
