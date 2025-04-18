class_name FpsCamera
extends PlayerCamera

@export var pathPivotSwing:NodePath
@export var pathPivotShakeHands:NodePath
@export var pathPivotTilt:NodePath
@export var pathPivotRecoil:NodePath
@export var pathPivotAimingPos:NodePath
@onready var pivotSwing:Marker3D = get_node(pathPivotSwing)
@onready var pivotTilt:Marker3D = get_node(pathPivotTilt)
@onready var pivotShakeHands:Marker3D = get_node(pathPivotShakeHands)
@onready var pivotRecoil:Marker3D = get_node(pathPivotRecoil)
@onready var pivotAimingPos:Marker3D = get_node(pathPivotAimingPos)

# Recoil
@export_category("Recoil Curves")
@export var curveRecoil:Curve
var posZRecoilStrength:float = 0.1             # definido pela arma
var rotXRecoilStrength:float = 10.0            # definido pela arma
var visualRecoilCurveOffset:float = 0.0        # faz as animacoes procedurais de recuo
var realRecoilRotVector:Vector2 = Vector2.ZERO # rotaciona o pivotRot da camera

# Aiming
var aimingPos:Vector3 = Vector3(-0.2, 0.15, 0.0) # definido pela arma


func _ready()->void:
	super._ready()
	pass


func _process(_delta:float)->void:
	delta = _delta
	
	handleSwingEffect()
	handleShakeEffect()
	handleTiltEffect()
	handleRecoilEffect()
	handleAimingPos()
	
	if(Input.is_action_just_pressed("Test")): addCameraShake(1.0)
	pivotShakeHands.position = shakePosOffset/4.0
	
	if(Input.is_action_just_pressed("Shoot")): addRecoil(0.1, 1.0)
	pass


func handleSwingEffect()->void:
	const SWING_IDLE_FREQUENCY:float = 0.002
	const SWING_WALKING_FREQUENCY:float = 0.01
	const SWING_IDLE_AMOUNT:float = 0.02
	const SWING_WALKING_AMOUNT:float = 0.04
	
	var frequence:float = (
		SWING_IDLE_FREQUENCY * int(!player.isMoving) +
		SWING_WALKING_FREQUENCY * int(player.isMoving) +
		SWING_WALKING_FREQUENCY * int(player.isSprinting)
	)
	var amount:float = (
		SWING_IDLE_AMOUNT * int(!player.isMoving) +
		SWING_WALKING_AMOUNT * int(player.isMoving)
	)
	
	# redução do efeito ao mirar
	frequence *= (0.5 * int(player.isAiming)) + (1.0 * int(!player.isAiming))
	amount *= (0.5 * int(player.isAiming)) + (1.0 * int(!player.isAiming))
	
	pivotSwing.position.x = lerp(pivotSwing.position.x, sin(Time.get_ticks_msec()*frequence*0.5)*amount, 10*delta)
	pivotSwing.position.y = lerp(pivotSwing.position.y, sin(Time.get_ticks_msec()*frequence)*amount, 10*delta)
	pass


func handleTiltEffect()->void:
	const EFFECT_STRENGTH:float = 5.0
	var targetRotZ:float = 0.0
	targetRotZ -= EFFECT_STRENGTH * Input.get_action_strength("MoveRight")
	targetRotZ += EFFECT_STRENGTH * Input.get_action_strength("MoveLeft")
	targetRotZ *= int(player.isMoving) # so aplica o efeito se o jogador estiver se movimentando
	
	var targetRotX:float = 0.0
	targetRotX -= EFFECT_STRENGTH/2.0 * Input.get_action_strength("MoveFoward")
	targetRotX += EFFECT_STRENGTH/2.0 * Input.get_action_strength("MoveBackwards")
	targetRotX *= int(player.isMoving) # so aplica o efeito se o jogador estiver se movimentando
	
	pivotTilt.rotation_degrees.z = lerp(pivotTilt.rotation_degrees.z, targetRotZ, 10*delta)
	pivotTilt.rotation_degrees.x = lerp(pivotTilt.rotation_degrees.x, targetRotX, 10*delta)
	pass


func handleRecoilEffect()->void:
	const DECREASE_FACTOR:float = 12.0
	
	pivotRecoil.position.z = curveRecoil.sample_baked(visualRecoilCurveOffset) * posZRecoilStrength
	pivotRecoil.rotation_degrees.x = curveRecoil.sample_baked(visualRecoilCurveOffset) * rotXRecoilStrength
	visualRecoilCurveOffset = lerp(visualRecoilCurveOffset, 0.0, DECREASE_FACTOR*delta)
	
	pivotRot.rotation_degrees.x += realRecoilRotVector.x
	pivotRot.rotation_degrees.y += realRecoilRotVector.y
	pivotRot.rotation_degrees.x = clamp(pivotRot.rotation_degrees.x, -CAMERA_X_RANGE, CAMERA_X_RANGE)
	realRecoilRotVector = lerp(realRecoilRotVector, Vector2.ZERO, DECREASE_FACTOR*delta)
	pass


func addRecoil(_effectStrength:float, _realRecoilStrength:float)->void:
	posZRecoilStrength = _effectStrength
	
	visualRecoilCurveOffset = 1.0
	
	realRecoilRotVector.x = _realRecoilStrength * randf_range(0.75, 1.0)
	realRecoilRotVector.y = _realRecoilStrength * randf_range(0.25, 0.35) * [1, -1].pick_random()
	pass


func handleAimingPos()->void:
	pivotAimingPos.position = lerp(
		pivotAimingPos.position,
		aimingPos * int(player.isAiming),
		8*delta
	)
	pass
