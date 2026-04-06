class_name NoiseSwayModule
extends Node

var _noisePosX := FastNoiseLite.new()
var _noisePosY := FastNoiseLite.new()
var _noiseRotX := FastNoiseLite.new()
var _noiseRotY := FastNoiseLite.new()

var posOffset: Vector3 = Vector3.ZERO
var rotOffset: Vector3 = Vector3.ZERO


func _ready():
	randomize()
	_noisePosX.seed = randi()
	_noisePosY.seed = randi()
	_noiseRotX.seed = randi()
	_noiseRotY.seed = randi()
	
	_noisePosX.noise_type = FastNoiseLite.TYPE_SIMPLEX
	_noisePosY.noise_type = FastNoiseLite.TYPE_SIMPLEX
	_noiseRotX.noise_type = FastNoiseLite.TYPE_SIMPLEX
	_noiseRotY.noise_type = FastNoiseLite.TYPE_SIMPLEX
	pass


func run(posOmplitude: float, rotAmplitude: float, frequency: float = 0.01):
	var _scaledTime: float = Time.get_ticks_msec() * frequency
	
	posOffset.x = _noisePosX.get_noise_1d(_scaledTime) * posOmplitude
	posOffset.y = _noisePosY.get_noise_1d(_scaledTime + 100.0) * posOmplitude
	rotOffset.x = _noiseRotX.get_noise_1d(_scaledTime + 200.0) * rotAmplitude
	rotOffset.y = _noiseRotY.get_noise_1d(_scaledTime + 300.0) * rotAmplitude
	pass
