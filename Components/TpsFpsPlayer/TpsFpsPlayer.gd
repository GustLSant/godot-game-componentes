class_name TpsFpsPlayer
extends CharacterBody3D

@onready var body:PlayerBody = $Body
@onready var collShape:CollisionShape3D = $CollShape

#region Movement
const MAX_WALKING_SPEED:float = 3.0
var currentSpeed:float = 0.0
var vecMovement:Vector3 = Vector3.ZERO
var yMovement:float = 0.0
var isMoving:bool = 0
var isStandingStill:bool = 0
const JUMP_STRENGTH:float = 12.5
const GRAVITY:float = 40.0
#endregion

#region Sprint
var stamina:float = 100.0
var isSprinting:bool = false
const SPRINT_STAMINA_COST:float = 20.0
const STAMINA_RECOVER_FACTOR:float = 5.0
const SPRINT_SPEED_MULTIPLIER:float = 2.0
#endregion

#region Camera Mode
enum CAMERA_MODES {FIRST_PERSON, THIRD_PERSON}
@onready var tpsCamera:TpsCamera = $TpsCamera
@onready var fpsCamera:FpsCamera = $FpsCamera
var currentCameraMode:CAMERA_MODES = CAMERA_MODES.THIRD_PERSON : set = setCurrentCameraMode
#endregion

#region Aim
enum AIM_MODES {HOLD, TOGGLE}
var aimMode:AIM_MODES = AIM_MODES.HOLD
var isAiming:bool = false
#endregion

var pdelta:float = 0.01


func _ready()->void:
	setCurrentCameraMode(CAMERA_MODES.THIRD_PERSON)
	pass


func _process(_delta:float)->void:
	handleChangeCameraMode()
	handleAimInput()
	pass


func _physics_process(_delta:float)->void:
	pdelta = _delta
	handleMovement()
	handleCollShapeRotation()
	pass


func handleMovement()->void:
	# movimentacao horizontal pelo jogador
	if(currentCameraMode == CAMERA_MODES.FIRST_PERSON):
		var cam_x = fpsCamera.pivotRot.global_transform.basis.x
		var cam_z = fpsCamera.pivotRot.global_transform.basis.z
		cam_x.y = 0
		cam_z.y = 0
		vecMovement = (Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft")) * cam_x
		vecMovement += (Input.get_action_strength("MoveBackwards") - Input.get_action_strength("MoveFoward")) * cam_z
	else:
		vecMovement = (Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft")) * tpsCamera.pivotRot.global_transform.basis.x
		vecMovement += (Input.get_action_strength("MoveBackwards") - Input.get_action_strength("MoveFoward")) * tpsCamera.pivotRot.global_transform.basis.z
	vecMovement = vecMovement.normalized()
	vecMovement.y = 0.0
	
	isMoving = vecMovement.x != 0 or vecMovement.z != 0
	isStandingStill = vecMovement.x == 0 and vecMovement.z == 0
	
	# sprint activation
	if(Input.is_action_just_pressed("Sprint") and stamina > SPRINT_STAMINA_COST): isSprinting = !isSprinting
	isSprinting = isSprinting and isMoving and (stamina > 0.0) and (not isAiming)
	
	# sprint usage
	var sprintSpeedMultiplier:float = (
		SPRINT_SPEED_MULTIPLIER*int(isSprinting) + 
		1.0*int(not isSprinting)
		)
	#stamina += (
		#-SPRINT_STAMINA_COST*pdelta*int(isSprinting) + 
		#STAMINA_RECOVER_FACTOR*pdelta*int(not isSprinting) 
		#)
	stamina = clamp(stamina, 0.0, 100.0)
	$Label.text = str(stamina)
	
	# gravidade e pulo
	if(self.is_on_floor()):
		if(Input.is_action_just_pressed("Jump")):
			yMovement = JUMP_STRENGTH
	else:
		yMovement -= GRAVITY * pdelta
		pass
	
	currentSpeed = lerp(currentSpeed, int(isMoving)*MAX_WALKING_SPEED, body.BLEND_TRANSITION_SPEED_FACTOR*pdelta)
	var finalHorizontalVelocity:Vector3 = vecMovement * currentSpeed * sprintSpeedMultiplier
	finalHorizontalVelocity *= (0.25 * int(isAiming)) + (1.0 * int(!isAiming)) # redução da velocidade quando estiver mirando
	
	self.velocity = finalHorizontalVelocity
	self.velocity.y = yMovement
	self.move_and_slide()
	pass


func handleCollShapeRotation()->void:
	if(currentCameraMode == CAMERA_MODES.FIRST_PERSON):
		collShape.rotation.y = fpsCamera.pivotRot.rotation.y
	else:
		collShape.rotation.y = body.pivotRot.rotation.y
	pass


func handleChangeCameraMode()->void:
	if(Input.is_action_just_pressed("ChangeCameraMode")):
		if(currentCameraMode == CAMERA_MODES.FIRST_PERSON):
			setCurrentCameraMode(CAMERA_MODES.THIRD_PERSON)
		else:
			setCurrentCameraMode(CAMERA_MODES.FIRST_PERSON)
	pass


func setCurrentCameraMode(_newCameraMode:CAMERA_MODES)->void:
	if(_newCameraMode == CAMERA_MODES.FIRST_PERSON):
		fpsCamera.setActive(true, tpsCamera.pivotRot.rotation)
		tpsCamera.setActive(false, fpsCamera.pivotRot.rotation)
		body.visible = false
		body.set_process(false)
		body.set_physics_process(false)
	else:
		fpsCamera.setActive(false, tpsCamera.pivotRot.rotation)
		tpsCamera.setActive(true, fpsCamera.pivotRot.rotation)
		body.visible = true
		body.set_process(true)
		body.set_physics_process(true)
		body.pivotRot.rotation.y = fpsCamera.pivotRot.rotation.y
	
	currentCameraMode = _newCameraMode
	pass


func handleAimInput()->void:
	if(aimMode == AIM_MODES.HOLD):
		isAiming = Input.is_action_pressed("Aim")
	else:
		if(Input.is_action_just_pressed("Aim")):
			isAiming = not isAiming
	pass
