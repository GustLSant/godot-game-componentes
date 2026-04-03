class_name PlayerContext
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


func _physics_process(_delta: float) -> void:
	gravityModule.run(player.is_on_floor(), _delta)
	fpsWalkModule.run(pivotRot.global_transform)
	sprintModule.run(player.is_on_floor(), Settings.sprintHoldMode, fpsWalkModule.state.inputVec, _delta)
	jumpModule.run(player.is_on_floor(), _delta)
	crouchModule.run(Settings.crouchHoldMode, not standShapeCast3D.is_colliding(), _delta)
	diveModule.run(fpsWalkModule.state.walkVec, player.is_on_floor(), _delta)
	strafeModule.run(true, _delta)
	fpsCameraRotModule.run(pivotRot, Settings.cameraSensitivity, Settings.cameraSensitivity, 200.0, 200.0, _delta)
	pass
