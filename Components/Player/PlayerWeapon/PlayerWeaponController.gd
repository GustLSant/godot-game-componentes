extends Node
class_name PlayerWeaponController

@onready var playerState: PlayerState = Nodes.playerState

@export var damage: float = 20.0
@export var fireRate: float = 0.15
@export var magazineSize: int = 30
@export var reloadTime: float = 2.5

@export_category("Nodes")
@export var shotRayCast: RayCast3D
@export var barrelNode: Node3D

@export_category("Aim Variables")
@export var armsDefaultPosition: Vector3 = Vector3(0.6, -0.65, -1.25)
@export var armsAimPosition: Vector3 = Vector3(0.0, -0.33, -1.0)
@export var aimFOV: float = 45.0

@export_category("Recoil Variables")
@export var recoverFactor: float = 1.0
@export var cameraRecoilStrength: float = 1.0
@export var recoilShakeStrength: float = 1.0
@export var recoilPosZStrength: float = 1.0
@export var recoilRotXStrength: float = 1.0
@export var recoilRotZStrength: float = 1.0

@export_category("ID")
@export var id: int = 0
@export var ammoId: int = 0

var isActive: bool = false : set = setActive
var currentFireCooldown: float = 0.0
var canTriggerReloadEndSignal: bool = false
var selfIdxOnInventory: int = -1
var delta: float = 0.016


func _init() -> void:
	Nodes.playerState.connect("ChangeWeapon", onChangeWeapon)
	self.connect("tree_exiting", onTreeExiting)
	pass


func _ready() -> void:
	getSelfIdxOnInventory()
	setActive(isActive)
	pass


func getSelfIdxOnInventory() -> void:
	for i in range(playerState.inventory["weapons"].size()):
		if(playerState.inventory["weapons"][i].id == self.id):
			selfIdxOnInventory = i
			return
	
	if(selfIdxOnInventory == -1): printerr("Não foi possível achar o idx da arma atual // id: ", self.id, " // weapon name: ", self.name, " // inventory: ", playerState.inventory["weapons"])
	pass


func _process(_delta: float) -> void:
	if(not isActive): return
	delta = _delta
	getAimInput()
	handleAtackRate()
	handleReload()
	pass


func _physics_process(delta: float) -> void:
	handleShootInput()
	pass


func getAimInput() -> void:
	if(Settings.aimHoldMode):
		playerState.isAiming = Input.is_action_pressed("Aim")
	else:
		if(Input.is_action_just_pressed("Aim")): playerState.isAiming = !playerState.isAiming
	pass


func handleShootInput() -> void:
	if(checkCanShoot()):
		playerState.inventory["weaponsAmmo"][selfIdxOnInventory] -= 1
		playerState.emit_signal("PlayerShot", cameraRecoilStrength)
		currentFireCooldown = playerState.fireRate
		
		shotRayCast.global_transform = playerState.currentCameraController.pivotRot.global_transform
		shotRayCast.force_raycast_update()
		var collider: Object = shotRayCast.get_collider()
		var distance: float = 99.0
		if(collider != null): distance = barrelNode.global_position.distance_to(shotRayCast.get_collision_point())
		
		spawnShotVfx(distance)
	pass


func checkCanShoot() -> bool:
	return( 
		Input.is_action_pressed("Shoot") and 
		currentFireCooldown <= 0.0 and 
		playerState.currentWeapon == self and 
		not playerState.isReloading and  
		playerState.inventory["weaponsAmmo"][selfIdxOnInventory] > 0 
	)


func handleReload() -> void:
	if(Input.is_action_just_pressed("Reload")):
		if(playerState.isReloading or playerState.inventory["weaponsAmmo"][selfIdxOnInventory] >= playerState.magazineSize or playerState.inventory["reserveAmmo"][ammoId] <= 0): return
		playerState.isReloading = true
		playerState.currentReloadTime = reloadTime
		canTriggerReloadEndSignal = true
	
	if(playerState.currentReloadTime > 0.0):
		playerState.currentReloadTime -= 1 * delta
	else:
		if(canTriggerReloadEndSignal):
			playerState.isReloading = false
			var ammoAmount: int = min(playerState.magazineSize, playerState.inventory["reserveAmmo"][ammoId]) - playerState.inventory["weaponsAmmo"][ammoId]
			playerState.inventory["weaponsAmmo"][selfIdxOnInventory] += ammoAmount
			playerState.inventory["reserveAmmo"][ammoId] -= ammoAmount
			playerState.emit_signal("ReloadEnd")
			canTriggerReloadEndSignal = false
	pass


func spawnShotVfx(_collDistance: float) -> void:
	var vfxInstance: Node3D = load("res://Components/Player/PlayerWeapon/Shot/PlayerShotVfx.tscn").instantiate()
	vfxInstance.transform = barrelNode.global_transform
	#vfxInstance.position += vfxInstance.transform.basis.z * 1.0
	vfxInstance.scale.z = _collDistance
	vfxInstance.call_deferred("look_at", playerState.currentPivotRot.global_position - playerState.currentPivotRot.global_transform.basis.z * 10.0)
	Nodes.mainNode.add_child(vfxInstance)
	pass


func handleAtackRate() -> void:
	currentFireCooldown -= 1 * delta
	pass


func setActive(_value: bool) -> void:
	isActive = _value
	self.visible = _value
	if(_value): setParametersOnPlayerState()
	pass


func setParametersOnPlayerState() -> void:
	playerState = Nodes.playerState # pq essa funcao pode ser chamada antes do ready
	
	playerState.damage = damage
	playerState.fireRate = fireRate
	playerState.magazineSize = magazineSize
	
	playerState.armsDefaultPosition = armsDefaultPosition
	playerState.armsAimPosition = armsAimPosition
	playerState.aimFOV = aimFOV
	
	playerState.recoverFactor = recoverFactor
	playerState.recoilShakeStrength = recoilShakeStrength
	playerState.recoilPosZStrength = recoilPosZStrength
	playerState.recoilRotXStrength = recoilRotXStrength
	playerState.recoilRotZStrength = recoilRotZStrength
	pass


func onChangeWeapon(_newWeapon: PlayerWeaponController) -> void:
	setActive(self == _newWeapon)
	pass


func onTreeExiting() -> void:
	playerState.inventory["reserveAmmo"][ammoId] += playerState.inventory["weaponsAmmo"][selfIdxOnInventory] # devolvendo a municao restante do pente para o inventario
	playerState.inventory["weaponsAmmo"][selfIdxOnInventory] = 0
	pass
