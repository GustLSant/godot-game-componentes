extends Node
class_name PlWp_ShootController

@onready var playerState: PlayerState = Nodes.playerState
@export var wpState: PlayerWeaponController


func _physics_process(delta: float) -> void:
	if(not wpState.isActive): return
	if(checkCanShoot()):
		shoot()
	pass


func checkCanShoot() -> bool:
	return( 
		Input.is_action_pressed("Shoot") and 
		wpState.currentFireCooldown <= 0.0 and 
		playerState.currentWeapon == wpState and 
		not playerState.isReloading and  
		playerState.inventory.weapons[wpState.selfIdxOnInventory].magazineAmmo > 0 
	)


func shoot() -> void:
	playerState.inventory.weapons[wpState.selfIdxOnInventory].magazineAmmo -= 1
	playerState.emit_signal("PlayerShot", wpState.cameraRecoilStrength)
	wpState.currentFireCooldown = playerState.fireRate
	
	wpState.shotRayCast.global_transform = wpState.barrelNode.global_transform #playerState.currentCameraController.pivotRot.global_transform
	wpState.shotRayCast.rotation_degrees.x += randf_range(-playerState.fireSpread, playerState.fireSpread)
	wpState.shotRayCast.rotation_degrees.y += randf_range(-playerState.fireSpread, playerState.fireSpread)
	
	wpState.shotRayCast.force_raycast_update()
	var collider: Object = wpState.shotRayCast.get_collider()
	var distance: float = 99.0
	var collisionPoint: Vector3 = wpState.shotRayCast.global_position - wpState.shotRayCast.global_transform.basis.z * distance
	if(collider != null): 
		collisionPoint = wpState.shotRayCast.get_collision_point()
		distance = wpState.barrelNode.global_position.distance_to(collisionPoint)
	
	spawnShotVfx(distance, collisionPoint)
	pass


func spawnShotVfx(_collDistance: float, _collPoint: Vector3) -> void:
	var vfxInstance: Node3D = load("res://Components/Player/PlayerWeapon/Shot/PlayerShotVfx.tscn").instantiate()
	vfxInstance.transform = wpState.barrelNode.global_transform
	vfxInstance.scale = Vector3.ONE
	vfxInstance.scale.z = _collDistance
	
	vfxInstance.call_deferred("look_at", _collPoint)
	Nodes.mainNode.add_child(vfxInstance)
	pass
