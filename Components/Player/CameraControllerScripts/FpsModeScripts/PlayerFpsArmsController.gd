extends PlayerModelController
class_name PlayerFpsArmsController

const ARMS_ROT_SPEED: float = 30.0
const ARMS_AIM_ROT_SPEED: float = 40.0

@export var weaponSocket: Node3D

var delta:float = 0.016


func _init() -> void:
	super._init()
	Nodes.playerState.connect("PickupWeapon", onPickupWeapon)
	Nodes.playerState.connect("TryChangeWeapon", onTryChangeWeapon)
	pass


func _ready() -> void:
	super._ready()
	pass


func _process(_delta: float) -> void:
	delta = _delta
	handleRotation()
	pass


func handleRotation() -> void:
	var speed: float = int(playerState.isAiming) * ARMS_AIM_ROT_SPEED + int(not playerState.isAiming) * ARMS_ROT_SPEED
	speed = speed * delta
	speed = min(speed, 1.0)
	speed = 1.0
	pivotRot.global_rotation.y = lerp_angle(pivotRot.global_rotation.y, playerState.currentPivotRot.global_rotation.y, speed)
	pivotRot.global_rotation.x = lerp_angle(pivotRot.global_rotation.x, playerState.currentPivotRot.global_rotation.x, speed)
	pass


func onPickupWeapon(_newWeaponScene: Node3D, _spawnOnPlayerModel: bool) -> void:
	if(_spawnOnPlayerModel):
		weaponSocket.call_deferred("add_child", _newWeaponScene)
	pass


func onTryChangeWeapon(_newWeaponScene: PlayerWeaponController) -> void:
	playerState.emit_signal("ChangeWeapon", _newWeaponScene) # normalmente toca a aniamcao de troca de arma, e no meio da animacao, equipa a arma
	pass
