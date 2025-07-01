class_name TpsCamera
extends PlayerCamera

#region Camera Collision
@export var pathShapeCast3D:NodePath
@onready var shapeCast3D:ShapeCast3D = get_node(pathShapeCast3D)

# Head Bobbing
@export var pathPivotBob:NodePath
@onready var pivotBob:Marker3D = get_node(pathPivotBob)
var currentBobAmplitude:float = 0.0

# Pos Damping
@export var pathPivotPosDamp:NodePath
@onready var pivotPosDamp:Marker3D = get_node(pathPivotPosDamp)

# Camera Target Position
const DEFAULT_CAMERA_TARGET_POS:Vector3 = Vector3(1.25, 1.0, 3.5)
const AIMING_CAMERA_TARGET_POS:Vector3 = Vector3(0.75, 0.75, 2.0)
var currentTargetPosition:Vector3 = DEFAULT_CAMERA_TARGET_POS

# Camera Side
var cameraSide:int = 1
var cameraSideMultiplierFactor:float = 1.0 # faz a transição suave do lado da câmera

# Recoil
var realRecoilRotVector:Vector2 = Vector2.ZERO


func _input(_event:InputEvent)->void:
	if(_event is InputEventMouseMotion):
		pivotRot.rotation_degrees.y -= _event.relative.x * CAMERA_SENSI * (0.5*int(player.isAiming) + 1.0*int(not player.isAiming))
		pivotRot.rotation_degrees.x -= _event.relative.y * CAMERA_SENSI * (0.5*int(player.isAiming) + 1.0*int(not player.isAiming))
		pivotRot.rotation_degrees.x = clamp(pivotRot.rotation_degrees.x, -CAMERA_X_RANGE, CAMERA_X_RANGE)
	pass


func _ready()->void:
	super._ready()
	pass


func _process(_delta:float)->void:
	delta = _delta
	
	handleCameraCollision()
	
	#    handleBobbingEffect()
	handlePosDamping()
	handleShakeEffect()
	handleCameraTargetPositioning()
	handleRecoilEffect()
	
	if(Input.is_action_just_pressed("Shoot")): addRecoil(2.0)
	return


func handleCameraCollision()->void:
	if(shapeCast3D.is_colliding()):
		cameraNode.position = shapeCast3D.target_position * shapeCast3D.get_closest_collision_safe_fraction()
	else:
		cameraNode.position = shapeCast3D.target_position
	pass


func handleBobbingEffect()->void:
	const WALK_BOB_FREQUENCY:float = 0.007
	const RUN_BOB_FREQUENCY_MULTIPLIER:float = 3.0
	const MAX_BOB_AMPLITUDE:float = 0.035
	
	currentBobAmplitude = lerp(currentBobAmplitude, MAX_BOB_AMPLITUDE * int(player.isMoving), 10*delta)
	
	var sprintFrequencyMultiplier:float = (
		1.0 * int(not player.isSprinting) +
		1.5 * int(player.isSprinting) -
		0.5 * int(player.isAiming)
	)
	var sprintAmplitudeMultiplier:float = (
		1.0 * int(not player.isSprinting) +
		2.0 * int(player.isSprinting) -
		0.5 * int(player.isAiming)
	)
	
	#pivotBob.position.x =  0.75*cos(Time.get_ticks_msec() * WALK_BOB_FREQUENCY*sprintFrequencyMultiplier) * currentBobAmplitude * sprintAmplitudeMultiplier
	pivotBob.position.y =  sin(2*Time.get_ticks_msec() * WALK_BOB_FREQUENCY*sprintFrequencyMultiplier) * currentBobAmplitude * sprintAmplitudeMultiplier
	pass

func handlePosDamping()->void:
	const POS_DAMPING_STRENGTH:float = 0.5
	
	var targetPos:Vector3 = Vector3(
		Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft"),
		0.0,
		Input.get_action_strength("MoveBackwards") - Input.get_action_strength("MoveFoward")
	)
	targetPos = targetPos.normalized() * int(player.vecMovement != Vector3.ZERO) # só aplica o efeito se o jogador estiver se movendo
	targetPos *= -1 * POS_DAMPING_STRENGTH * (1.0*int(not player.isAiming) + 0.5*int(player.isAiming)) # invertendo e aplicando a forca (aplica a força somente se o jogador não estiver mirando
	
	pivotPosDamp.position = lerp(pivotPosDamp.position, targetPos, 5*delta)
	pass


func handleCameraTargetPositioning()->void:
	handleCameraSide()
	
	if(player.isAiming):
		currentTargetPosition = lerp(
			currentTargetPosition,
			Vector3(AIMING_CAMERA_TARGET_POS.x * cameraSideMultiplierFactor, AIMING_CAMERA_TARGET_POS.y, AIMING_CAMERA_TARGET_POS.z),
			8*delta
		)
	else:
		currentTargetPosition = lerp(
			currentTargetPosition,
			Vector3(DEFAULT_CAMERA_TARGET_POS.x * cameraSideMultiplierFactor, DEFAULT_CAMERA_TARGET_POS.y, DEFAULT_CAMERA_TARGET_POS.z),
			8*delta
		)
	
	shapeCast3D.target_position = currentTargetPosition
	pass

func handleCameraSide()->void:
	if(Input.is_action_just_pressed("ToggleCameraSide")): cameraSide *= -1
	cameraSideMultiplierFactor = lerp(cameraSideMultiplierFactor, float(cameraSide), 8*delta)
	pass


func handleRecoilEffect()->void:
	const DECREASE_FACTOR:float = 12.0
	
	pivotRot.rotation_degrees.x += realRecoilRotVector.x
	pivotRot.rotation_degrees.y += realRecoilRotVector.y
	pivotRot.rotation_degrees.x = clamp(pivotRot.rotation_degrees.x, -CAMERA_X_RANGE, CAMERA_X_RANGE)
	realRecoilRotVector = lerp(realRecoilRotVector, Vector2.ZERO, DECREASE_FACTOR*delta)
	pass

func addRecoil(_realRecoilStrength:float)->void:
	realRecoilRotVector.x = _realRecoilStrength * randf_range(0.75, 1.0)
	realRecoilRotVector.y = _realRecoilStrength * randf_range(0.25, 0.35) * [1, -1].pick_random()
	pass


func printOnLabel2(value)->void:
	$"../Label2".text = str(value)
	pass
