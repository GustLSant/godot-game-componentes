extends Node
class_name PlayerWeaponController

@onready var playerState: PlayerState = Nodes.playerState

@export var damage: float = 20.0
@export var fireRate: float = 0.15

@export_category("Aim Variables")
@export var armsDefaultPosition: Vector3 = Vector3(0.6, -1.0, 0.2)
@export var armsAimPosition: Vector3 = Vector3(0.0, -0.57, 0.4)
@export var aimFOV: float = 45.0

@export_category("Recoil Variables")
@export var cameraRecoilStrength:float = 1.0
@export var recoilShakeStrength: float = 1.0
@export var recoilPosZStrength: float = 1.0
@export var recoilRotXStrength: float = 1.0
@export var recoilRotZStrength: float = 1.0

var isActive: bool = true : set = setActive
var currentFireCooldown: float = 0.0
var delta: float = 0.016


func _ready() -> void:
	if(isActive): setParametersOnPlayerState()
	pass


func _process(_delta: float) -> void:
	delta = _delta
	getAimInput()
	handleShootInput()
	handleAtackRate()
	pass


func getAimInput() -> void:
	if(Settings.aimHoldMode):
		playerState.isAiming = Input.is_action_pressed("Aim")
	else:
		if(Input.is_action_just_pressed("Aim")): playerState.isAiming = !playerState.isAiming
	pass


func handleShootInput() -> void:
	if(Input.is_action_pressed("Shoot") and currentFireCooldown <= 0.0 and playerState.inventory.size() > 0):
		playerState.emit_signal("PlayerShot", cameraRecoilStrength)
		currentFireCooldown = playerState.fireRate
	pass


func handleAtackRate() -> void:
	currentFireCooldown -= 1 * delta
	pass


func setActive(_value: bool) -> void:
	isActive = _value
	self.set_process(_value)
	self.set_physics_process(_value)
	self.visible = _value
	if(_value):
		setParametersOnPlayerState()
		playerState.currentWeapon = self
	pass


func setParametersOnPlayerState() -> void:
	playerState = Nodes.playerState # pq essa funcao pode ser chamada antes do ready
	
	playerState.damage = damage
	playerState.fireRate = fireRate
	
	playerState.armsDefaultPosition = armsDefaultPosition
	playerState.armsAimPosition = armsAimPosition
	playerState.aimFOV = aimFOV
	
	playerState.recoilShakeStrength = recoilShakeStrength
	playerState.recoilPosZStrength = recoilPosZStrength
	playerState.recoilRotXStrength = recoilRotXStrength
	playerState.recoilRotZStrength = recoilRotZStrength
	pass
