extends Node
class_name PlWp_ShootController

@onready var player: Player = Nodes.player
@export var weapon: PlayerWeapon

var delta: float = 0.016


func _physics_process(_delta: float) -> void:
	if(not weapon.isActive): return
	
	delta = _delta
	handleFireRate()
	if(handleShootInput()): shoot()
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
	player.emit_signal("PlayerShot", weapon.cameraRecoilStrength)
	weapon.currentFireCooldown = player.fireRate
	
	weapon.shotRayCast.global_transform = weapon.barrelNode.global_transform #player.currentCameraController.pivotRot.global_transform
	weapon.shotRayCast.rotation_degrees.x += randf_range(-player.fireSpread, player.fireSpread)
	weapon.shotRayCast.rotation_degrees.y += randf_range(-player.fireSpread, player.fireSpread)
	
	weapon.shotRayCast.force_raycast_update()
	var collider: Object = weapon.shotRayCast.get_collider()
	var distance: float = 99.0
	var collisionPoint: Vector3 = weapon.shotRayCast.global_position - weapon.shotRayCast.global_transform.basis.z * distance
	if(collider != null): 
		collisionPoint = weapon.shotRayCast.get_collision_point()
		distance = weapon.barrelNode.global_position.distance_to(collisionPoint)
	
	spawnShotVfx(distance, collisionPoint)
	pass


func handleFireRate() -> void:
	weapon.currentFireCooldown -= 1 * delta
	pass


func spawnShotVfx(_collDistance: float, _collPoint: Vector3) -> void:
	var vfxInstance: Node3D = load("res://Components/PlayerWeapons/Shot/PlayerShotVfx.tscn").instantiate()
	vfxInstance.transform = weapon.barrelNode.global_transform
	vfxInstance.scale = Vector3.ONE
	vfxInstance.scale.z = _collDistance
	
	vfxInstance.call_deferred("look_at", _collPoint)
	Nodes.mainNode.add_child(vfxInstance)
	pass
