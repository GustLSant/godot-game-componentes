extends Node
class_name PlayerWeaponController

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
		PlayerState.isAiming = Input.is_action_pressed("Aim")
	else:
		if(Input.is_action_just_pressed("Aim")): PlayerState.isAiming = !PlayerState.isAiming
	pass


func handleShootInput() -> void:
	if(Input.is_action_pressed("Shoot") and currentFireCooldown <= 0.0 and PlayerState.inventory.size() > 0):
		PlayerState.emit_signal("PlayerShot", cameraRecoilStrength)
		currentFireCooldown = PlayerState.fireRate
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
		PlayerState.currentWeapon = self
	pass


func setParametersOnPlayerState() -> void:
	PlayerState.damage = damage
	PlayerState.fireRate = fireRate
	
	PlayerState.armsDefaultPosition = armsDefaultPosition
	PlayerState.armsAimPosition = armsAimPosition
	PlayerState.aimFOV = aimFOV
	
	PlayerState.recoilShakeStrength = recoilShakeStrength
	PlayerState.recoilPosZStrength = recoilPosZStrength
	PlayerState.recoilRotXStrength = recoilRotXStrength
	PlayerState.recoilRotZStrength = recoilRotZStrength
	pass
