class_name PlayerContext
extends Node3D

# controllers
@export var fpsWalkController: FpsWalkController
@export var sprintController: SprintController
@export var jumpController: JumpController
@export var crouchController: CrouchController
@export var strafeController: StrafeController
@export var fpsCameraRotController: FpsCameraRotController

# dados
@export var player: CharacterBody3D
@export var pivotRot: Node3D
@export var standShapeCast3D: ShapeCast3D


func _physics_process(_delta: float) -> void:
	fpsWalkController.run(pivotRot.global_transform)
	sprintController.run(player.is_on_floor(), Settings.sprintHoldMode, fpsWalkController.state.inputVec, _delta)
	jumpController.run(player.is_on_floor(), _delta)
	crouchController.run(Settings.crouchHoldMode, not standShapeCast3D.is_colliding(), _delta)
	strafeController.run(true, _delta)
	fpsCameraRotController.run(pivotRot, Settings.cameraSensitivity, Settings.cameraSensitivity, 200.0, 200.0, _delta)
	pass
