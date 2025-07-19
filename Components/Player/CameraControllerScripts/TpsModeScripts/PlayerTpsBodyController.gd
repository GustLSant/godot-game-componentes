extends PlayerModelController
class_name PlayerTpsBodyController

@export var pivotRefRot: Marker3D
@export var animTree: AnimationTree
@onready var animStateMachine:AnimationNodeStateMachinePlayback = animTree.get("parameters/StateMachine/playback")
var currentAnimation: String
var fallingBlendAmount: float = 0.0
const ANIMATIONS: Array[String] = [
	"TPose",             # 0
	"IdleBlendTree",     # 1
	"WalkingBlendTree",  # 2
	"SprintBlendTree",   # 3
	"AimBlendTree",      # 4
]
enum {
	TPOSE_IDX     = 0,
	IDLE_IDX      = 1,
	WALKING_IDX   = 2,
	SPRINTING_IDX = 3,
	AIM_IDX       = 4
	}

var delta: float = 0.016


func _process(_delta: float) -> void:
	delta = _delta
	handleRotation()
	handleAimBehaviour()
	handleAnimation()
	pass


func handleRotation() -> void:
	if(Nodes.player.velocity.x != 0.0 or Nodes.player.velocity.z != 0.0):
		pivotRefRot.look_at(self.global_position + Nodes.player.velocity)
		pivotRot.global_rotation.y = lerp_angle(pivotRot.global_rotation.y, pivotRefRot.global_rotation.y, 10 * delta)
	pass


func handleAimBehaviour() -> void:
	pivotRot.global_rotation.y = int(playerState.isAiming) * playerState.currentPivotRot.global_rotation.y + int(not playerState.isAiming) * pivotRot.global_rotation.y
	pass


func handleAnimation() -> void:
	var animIdx: int = getCurrentAnimationIdx()
	tryChangeAnimation(ANIMATIONS[animIdx], animIdx)
	
	fallingBlendAmount = lerp(fallingBlendAmount, float(not playerState.isOnFloor), 20*delta)
	animTree["parameters/BlendFalling/blend_amount"] = fallingBlendAmount
	animTree["parameters/StateMachine/AimBlendTree/BlendAimAngle/blend_amount"] = playerState.currentCameraController.pivotRot.rotation_degrees.x / playerState.currentCameraController.CAMERA_X_RANGE
	pass


func getCurrentAnimationIdx() -> int:
	var animIdx: int = 0
	var isPlayerMoving: bool = (Nodes.player.velocity.x != 0.0) or (Nodes.player.velocity.z != 0.0)
	
	animIdx += int(
		not playerState.isAiming and
		Nodes.player.velocity == Vector3.ZERO
	) * IDLE_IDX
	
	animIdx += int(
		not playerState.isAiming and
		isPlayerMoving and 
		not playerState.isSprinting
	) * WALKING_IDX
	
	animIdx += int(
		not playerState.isAiming and
		isPlayerMoving and 
		playerState.isSprinting
	) * SPRINTING_IDX
	
	animIdx += int(
		playerState.isAiming
	) * AIM_IDX
	
	if(animIdx >= ANIMATIONS.size()): printerr("idx de animacao maior que o permitido: ", animIdx)
	animIdx = min(animIdx, ANIMATIONS.size() - 1) # tratamento para nao acessar valor fora do array
	
	return animIdx


func tryChangeAnimation(_newAnimation: String, _immediate: bool = false) -> void:
	if(_newAnimation != currentAnimation):
		animStateMachine.travel(_newAnimation)
		currentAnimation = _newAnimation
	else:
		return
	pass
