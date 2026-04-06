class_name DiveModule
extends Node

enum DIVE_STATE { IDLE, FALLING, STANDING }

const INITIAL_COLLIDER_SIZE: Vector3 = Vector3(1.0, 2.0, 1.0)
const FALLING_COLLIDER_SIZE: Vector3 = Vector3.ONE

const INITIAL_COLLIDER_HEIGHT: float = 1.0
const FALLING_COLLIDER_HEIGHT: float = 1.5

const VERTICAL_IMPULSE_STRENGTH: float = 4.5
const HORIZONTAL_IMPULSE_STREGTH: float = 6.0

const LERP_FACTOR: float = 8.0

signal DiveStarted()
signal DiveLanded()
signal DiveFinished()

var _standingTween: Tween

var isDiving: bool :
	get: return currentState != DIVE_STATE.IDLE
var currentState: DIVE_STATE = DIVE_STATE.IDLE
var currentColliderSize: Vector3 = INITIAL_COLLIDER_SIZE
var currentColliderHeight: float = INITIAL_COLLIDER_HEIGHT
var motion: Vector3 = Vector3.ZERO


func run(moveVec: Vector3, isPlayerOnFloor: bool, canHandleInput: bool = true) -> void:
	_handleMachineState(moveVec, isPlayerOnFloor, canHandleInput)
	pass


func _handleMachineState(moveVec: Vector3, isPlayerOnFloor: bool, canHandleInput: bool) -> void:
	match currentState:
		DIVE_STATE.IDLE: _handleIdleState(moveVec, isPlayerOnFloor, canHandleInput)
		DIVE_STATE.FALLING: _handleFallingState(isPlayerOnFloor)
		DIVE_STATE.STANDING: _handleStandingState()
	pass


func _handleIdleState(moveVec: Vector3, isPlayerOnFloor: bool, canHandleInput: bool) -> void:
	var isIdle: bool = currentState == DIVE_STATE.IDLE
	var isMoving: bool = abs(moveVec.length()) > 0.0
	
	if (isIdle and isPlayerOnFloor and isMoving and canHandleInput and Input.is_action_just_pressed("Dive")):
		_setFallingState(moveVec)
	pass


func _handleFallingState(isPlayerOnFloor: bool) -> void:
	if (isPlayerOnFloor): _setStandingState()
	pass


func _handleStandingState() -> void:
	pass


func _setIdleState() -> void:
	_standingTween = null
	emit_signal('DiveFinished')
	currentState = DIVE_STATE.IDLE
	pass


func _setFallingState(moveVec: Vector3) -> void:
	currentColliderHeight = FALLING_COLLIDER_HEIGHT
	currentColliderSize = FALLING_COLLIDER_SIZE
	
	var movVecNormalized: Vector3 = moveVec.normalized()
	
	motion = Vector3(
		movVecNormalized.x * HORIZONTAL_IMPULSE_STREGTH,
		VERTICAL_IMPULSE_STRENGTH,
		movVecNormalized.z * HORIZONTAL_IMPULSE_STREGTH
	)
	
	emit_signal('DiveStarted')
	currentState = DIVE_STATE.FALLING
	pass


func _setStandingState() -> void:
	if _standingTween:
		_standingTween.kill()
	
	_standingTween = create_tween()
	_standingTween.set_parallel(true)
	
	_standingTween.tween_property(self, 'motion', Vector3.ZERO, 0.2)
	_standingTween.tween_property(self, 'currentColliderHeight', INITIAL_COLLIDER_HEIGHT, 0.2)
	_standingTween.tween_property(self, 'currentColliderSize', INITIAL_COLLIDER_SIZE, 0.2)
	
	_standingTween.finished.connect(_setIdleState)
	
	emit_signal('DiveLanded')
	currentState = DIVE_STATE.STANDING
	pass
