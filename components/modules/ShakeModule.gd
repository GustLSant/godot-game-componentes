class_name ShakeModule
extends Node

const FREQUENCY: float = 1000.0
const DECAY: float = 1.5
const MAX_STRENGTH: float = 5.0
const MAX_AMPLITUDE: float = 0.25
const MAX_ROT_AMPLITUDE: float = 15.0

const ROT_AMPLITUDE: float = 5.0

var _time: float = 0.0
var _strength: float = 0.0

var _noiseX := FastNoiseLite.new()
var _noiseY := FastNoiseLite.new()
var _noiseR := FastNoiseLite.new()

var isActive: bool :
	get: return _strength > 0.001
var posOffset: Vector3 = Vector3.ZERO
var rotOffset: Vector3 = Vector3.ZERO


func _ready():
	randomize()
	_noiseX.seed = randi()
	_noiseY.seed = randi()
	_noiseR.seed = randi()
	
	_noiseX.noise_type = FastNoiseLite.TYPE_SIMPLEX
	_noiseY.noise_type = FastNoiseLite.TYPE_SIMPLEX
	_noiseR.noise_type = FastNoiseLite.TYPE_SIMPLEX
	pass


func run(delta: float):
	_time += delta
	
	_strength -= DECAY * delta
	_strength = max(_strength, 0.0)
	
	var _scaledTime: float = _time * FREQUENCY
	
	posOffset.x = _noiseX.get_noise_1d(_scaledTime) * _strength
	posOffset.y = _noiseY.get_noise_1d(_scaledTime + 100.0) * _strength
	
	rotOffset.z = _noiseR.get_noise_1d(_scaledTime + 200.0) * ROT_AMPLITUDE * _strength
	
	posOffset.x = clamp(posOffset.x, -MAX_AMPLITUDE, MAX_AMPLITUDE)
	posOffset.y = clamp(posOffset.y, -MAX_AMPLITUDE, MAX_AMPLITUDE)
	rotOffset.z = clamp(posOffset.z, -MAX_ROT_AMPLITUDE, MAX_ROT_AMPLITUDE)
	pass


func addShake(impulse: float):
	_strength += impulse
	_strength = clamp(_strength, 0.0, MAX_STRENGTH)
	pass


func stop():
	_strength = 0.0
	pass
