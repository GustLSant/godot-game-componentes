class_name SineSwayModule
extends Node

const FREQUENCY_MULTIPLIER: float = 0.01

const X_AMPLITUDE_MULTIPLIER: float = 0.0375
const Y_AMPLITUDE_MULTIPLIER: float = 0.075

var posOffset: Vector3 = Vector3.ZERO


func run(frequency: float, amplitude: float) -> void:
	posOffset = Vector3(
		sin(Time.get_ticks_msec() * frequency * FREQUENCY_MULTIPLIER * 0.5) * amplitude * X_AMPLITUDE_MULTIPLIER,
		sin(Time.get_ticks_msec() * frequency * FREQUENCY_MULTIPLIER)       * amplitude * Y_AMPLITUDE_MULTIPLIER,
		0.0
	)
	pass
