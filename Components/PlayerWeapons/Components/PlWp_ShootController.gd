extends Node
class_name PlWp_ShootController

@onready var player: Player = Nodes.player
@export var wpState: PlayerWeapon

var delta: float = 0.016


func _physics_process(_delta: float) -> void:
	if(not wpState.isActive): return
	
	delta = _delta
	handleFireRate()
	if(handleShootInput()): shoot()
	pass


func handleShootInput() -> bool:
	return( 
		Input.is_action_pressed("Shoot") and 
		wpState.currentFireCooldown <= 0.0 and 
		player.currentWeapon == wpState and 
		not player.isReloading and  
		wpState.magazineAmmo > 0 
	)


func shoot() -> void:
	wpState.magazineAmmo -= 1
	player.emit_signal("PlayerShot", wpState.cameraRecoilStrength)
	wpState.currentFireCooldown = player.fireRate
	
	wpState.shotRayCast.global_transform = wpState.barrelNode.global_transform #player.currentCameraController.pivotRot.global_transform
	wpState.shotRayCast.rotation_degrees.x += randf_range(-player.fireSpread, player.fireSpread)
	wpState.shotRayCast.rotation_degrees.y += randf_range(-player.fireSpread, player.fireSpread)
	
	wpState.shotRayCast.force_raycast_update()
	var collider: Object = wpState.shotRayCast.get_collider()
	var distance: float = 99.0
	var collisionPoint: Vector3 = wpState.shotRayCast.global_position - wpState.shotRayCast.global_transform.basis.z * distance
	if(collider != null): 
		collisionPoint = wpState.shotRayCast.get_collision_point()
		distance = wpState.barrelNode.global_position.distance_to(collisionPoint)
	
	spawnShotVfx(distance, collisionPoint)
	pass


func handleFireRate() -> void:
	wpState.currentFireCooldown -= 1 * delta
	pass


func spawnShotVfx(_collDistance: float, _collPoint: Vector3) -> void:
	var vfxInstance: Node3D = load("res://Components/PlayerWeapons/Shot/PlayerShotVfx.tscn").instantiate()
	vfxInstance.transform = wpState.barrelNode.global_transform
	vfxInstance.scale = Vector3.ONE
	vfxInstance.scale.z = _collDistance
	
	vfxInstance.call_deferred("look_at", _collPoint)
	Nodes.mainNode.add_child(vfxInstance)
	pass
