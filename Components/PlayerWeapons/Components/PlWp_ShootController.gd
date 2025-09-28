extends Node
class_name PlWp_ShootController

@onready var player: Player = Nodes.player
@export var weapon: PlayerWeapon
@export var barrelNode: Node3D
@export var socketShotRaycastDefaultPos: Node3D
@export var shotRaycast: RayCast3D

var delta: float = 0.016


func _physics_process(_delta: float) -> void:
	if(not weapon.isActive): return
	
	delta = _delta
	handleFireRate()
	handleShotRaycastAimBBehaviour()
	if(handleShootInput()): shoot()
	pass


func handleShotRaycastAimBBehaviour() -> void:
	var targetPos: Vector3 = (
		int(player.isAiming) * player.currentCameraController.camera.global_position + 
		int(not player.isAiming) * socketShotRaycastDefaultPos.global_position
	)
	
	shotRaycast.global_position = lerp(shotRaycast.global_position, targetPos, player.AIM_SPEED * 2.0 * delta)
	#shotRaycast.global_position = targetPos
	pass


func handleShootInput() -> bool:
	return( 
		Input.is_action_pressed("Shoot") and 
		weapon.currentFireCooldown <= 0.0 and 
		player.currentWeapon == weapon and 
		not player.isReloading and  
		weapon.magazineAmmo > 0 
	)


func shoot() -> void:
	weapon.magazineAmmo -= 1
	
	var payload: T_PlayerShotPayload = T_PlayerShotPayload.new()
	payload.cameraRecoilRotStrength = weapon.cameraRecoilRotStrength
	payload.cameraRecoilShakeStrength = weapon.cameraRecoilShakeStrength
	player.emit_signal("PlayerShot", payload)
	
	weapon.currentFireCooldown = player.fireRate
	
	for i in range(weapon.shotsCount):
		#shotRaycast.global_transform = barrelNode.global_transform #player.currentCameraController.pivotRot.global_transform
		shotRaycast.rotation_degrees.x = randf_range(-player.fireSpread - weapon.inheritFireSpread, player.fireSpread + weapon.inheritFireSpread)
		shotRaycast.rotation_degrees.y = randf_range(-player.fireSpread - weapon.inheritFireSpread, player.fireSpread + weapon.inheritFireSpread)
		
		shotRaycast.force_raycast_update()
		var collider: Object = shotRaycast.get_collider()
		var collisionPoint: Vector3 = shotRaycast.global_position - shotRaycast.global_transform.basis.z * 99.0
		if(collider != null): 
			collisionPoint = shotRaycast.get_collision_point()
			if(collider is Hurtbox): collider.healthController.takeDamage(weapon.damage, collisionPoint)
		
		Nodes.playerShotVfxManager.requestInstance(1, barrelNode.global_transform)
		#spawnShotVfx(collisionPoint)
	pass


func handleFireRate() -> void:
	weapon.currentFireCooldown -= 1 * delta
	pass


func spawnShotVfx(_collPoint: Vector3) -> void:
	var vfxInstance: Node3D = load("res://Components/PlayerWeapons/Shot/PlayerShotVfx.tscn").instantiate()
	vfxInstance.transform = barrelNode.global_transform
	vfxInstance.scale = Vector3.ONE
	#vfxInstance.scale.z = barrelNode.global_position.distance_to(_collPoint)
	
	vfxInstance.call_deferred("look_at", _collPoint)
	Nodes.mainNode.add_child(vfxInstance)
	pass
