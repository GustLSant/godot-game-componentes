class_name PlayerManager
extends Node3D

# controllers
@export var gravityModule: GravityModule
@export var fpsWalkModule: FpsWalkModule
@export var sprintModule: SprintModule
@export var jumpModule: JumpModule
@export var crouchModule: CrouchModule
@export var diveModule: DiveModule
@export var strafeModule: StrafeModule
@export var fpsCameraRotModule: FpsCameraRotModule

# dados
@export var player: CharacterBody3D
@export var camera: Camera3D
@export var pivotRot: Node3D
@export var standShapeCast3D: ShapeCast3D


func _ready() -> void:
	crouchModule.connect("CrouchChanged", handleCrouchChanged)
	sprintModule.connect("SprintChanged", handleSprintChanged)
	pass


func _physics_process(_delta: float) -> void:
	gravityModule.run(player.is_on_floor(), _delta)
	fpsWalkModule.run(pivotRot.global_transform)
	strafeModule.run(Settings.strafeHoldMode, _delta)
	fpsCameraRotModule.run(pivotRot.rotation_degrees, Settings.cameraSensitivity, Settings.cameraSensitivity, 200.0, 200.0, _delta)
	diveModule.run(fpsWalkModule.walkVec, player.is_on_floor())
	
	if (not diveModule.isDiving):
		sprintModule.run(player.is_on_floor(), Settings.sprintHoldMode, fpsWalkModule.inputVec, _delta)
		jumpModule.run(player.is_on_floor())
		crouchModule.run(Settings.crouchHoldMode, not standShapeCast3D.is_colliding(), _delta)
	pass


func handleCrouchChanged(_newState: bool) -> void:
	#if (_newState): sprintModule.changeSprinting(false)
	pass


func handleSprintChanged(_newState: bool) -> void:
	#if (_newState): crouchModule.changeCrouch(false)
	pass
