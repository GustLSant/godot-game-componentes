extends PlayerModelController
class_name PlayerTpsBodyController

@export var pivotRefRot: Marker3D
@export var animTree: AnimationTree
@onready var animStateMachine:AnimationNodeStateMachinePlayback = animTree.get("parameters/playback")
var currentAnimation: String
const ANIMATIONS: Array[String] = [
	"TPose",             # 0
	"Idle",              # 1
	"WalkingBlendTree",  # 2
	"SprintBlendTree",   # 3
	"Falling",           # 4
]
enum {
	TPOSE_IDX     = 0,
	IDLE_IDX      = 1,
	WALKING_IDX   = 2,
	SPRINTING_IDX = 3,
	FALLING_IDX   = 4
	}

var delta: float = 0.016


func _process(_delta: float) -> void:
	delta = _delta
	handleRotation()
	handleAimBehaviour()
	handleAnimation()
	pass


func handleRotation() -> void:
	if(playerState.player.velocity.x != 0.0 or playerState.player.velocity.z != 0.0):
		pivotRefRot.look_at(self.global_position + playerState.player.velocity)
		pivotRot.global_rotation.y = lerp_angle(pivotRot.global_rotation.y, pivotRefRot.global_rotation.y, 10 * delta)
	pass


func handleAimBehaviour() -> void:
	pivotRot.global_rotation.y = int(playerState.isAiming) * playerState.currentPivotRot.global_rotation.y + int(not playerState.isAiming) * pivotRot.global_rotation.y
	pass


func handleAnimation() -> void:
	var animIdx: int = 0
	var isPlayerMoving: bool = (playerState.player.velocity.x != 0.0) or (playerState.player.velocity.z != 0.0)
	
	animIdx += int(
		playerState.isOnFloor and 
		playerState.player.velocity == Vector3.ZERO
	) * IDLE_IDX
	
	animIdx += int(
		playerState.isOnFloor and 
		isPlayerMoving and 
		not playerState.isSprinting
	) * WALKING_IDX
	
	animIdx += int(
		playerState.isOnFloor and 
		isPlayerMoving and 
		playerState.isSprinting
	) * SPRINTING_IDX
	
	animIdx += int(
		not playerState.isOnFloor
	) * FALLING_IDX
	
	if(animIdx >= ANIMATIONS.size()): printerr("idx de animacao maior que o permitido: ", animIdx)
	animIdx = min(animIdx, ANIMATIONS.size() - 1) # tratamento para nao acessar valor fora do array
	tryChangeAnimation(ANIMATIONS[animIdx], animIdx == FALLING_IDX) # precisa desse imediate pq senao a aninacao de andar pode ser setada antes da falling, e ai vai esperar posicionar na Walking antes de passar pra Falling
	pass


func tryChangeAnimation(_newAnimation: String, _immediate: bool = false) -> void:
	if(_newAnimation != currentAnimation):
		if(_immediate):
			animStateMachine.start(_newAnimation)
		else:
			animStateMachine.travel(_newAnimation)
		currentAnimation = _newAnimation
	else:
		return
	pass
