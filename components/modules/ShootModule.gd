class_name ShootModule
extends Node

signal Shot()

var _shotTimer: float = 0.0

var canShoot: bool = true
var _fireIntervalFraction: float = 0.0


func run(canHoldFire: bool, fireInterval: float, delta: float, canHandleInput: bool = true) -> void:
	_handleCanShoot(fireInterval, delta)
	_setFireIntervalFraction(fireInterval)
	_handleInput(canHoldFire, canHandleInput)
	pass


func _handleCanShoot(fireInterval: float, delta: float) -> void:
	_shotTimer += 1 * delta
	canShoot = _shotTimer >= fireInterval
	pass


func _setFireIntervalFraction(fireInterval: float) -> void:
	_fireIntervalFraction = _shotTimer / fireInterval
	_fireIntervalFraction = min(_fireIntervalFraction, 1.0)
	pass


func _handleInput(canHoldFire: bool, canHandleInput: bool) -> void:
	if (not canHandleInput): return
	
	var canTriggerShot: bool = (
		(canHoldFire and canShoot and Input.is_action_pressed('Shoot'))
		or
		(not canHoldFire and canShoot and Input.is_action_just_pressed('Shoot'))
	)
	if (canTriggerShot): _shoot()
	pass


func _shoot() -> void:
	canShoot = false
	_shotTimer = 0.0
	emit_signal('Shot')
	pass
