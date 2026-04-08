class_name PlayerCameraMapper
extends Node

@export var manager: PlayerManager
@export var pivotRot: Marker3D
@export var pivotStrafe: Marker3D
@export var pivotCrouch: Marker3D
@export var pivotShake: Marker3D
@export var pivotSineSway: Marker3D
@export var pivotNoiseSway: Marker3D
@export var pivotRecoil: Marker3D
@export var pivotLead: Marker3D
@export var pivotTilt: Marker3D
@export var camera: Camera3D


func _physics_process(_delta: float) -> void:
	pivotRot.rotation_degrees = manager.fpsCameraRotModule.targetRotation
	
	pivotCrouch.position.y = manager.crouchModule.heightOffset
	
	pivotShake.position = manager.shakeModule.posOffset
	pivotShake.rotation_degrees = manager.shakeModule.rotOffset
	
	pivotSineSway.position = manager.sineSwayModule.posOffset
	#pivotNoiseSway.position = manager.noiseSwayModule.posOffset
	#pivotNoiseSway.rotation_degrees = manager.noiseSwayModule.rotOffset
	
	pivotStrafe.rotation_degrees.z = manager.strafeModule.currentCameraAngle
	pivotStrafe.position.x = manager.strafeModule.currentPosOffset.x
	pivotStrafe.position.y = manager.strafeModule.currentPosOffset.y
	
	pivotRecoil.position = manager.recoilModule.posOffset
	pivotRecoil.rotation_degrees = manager.recoilModule.rotOffset
	
	pivotLead.rotation_degrees = manager.lookLeadModule.rotOffset
	pivotTilt.rotation_degrees = manager.movementTiltModule.rotOffset
	
	camera.fov = 75.0 - (15.0 * manager.aimModule.aimFactor)
	pass
