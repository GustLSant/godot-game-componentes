class_name PlayerMovementContext
extends Node

@export var walkController: WalkController
@export var sprintController: SprintController
@export var jumpController: JumpController
@export var crouchController: CrouchController

@export var player: CharacterBody3D
@export var pivotRot: Node3D


func _ready() -> void:
	crouchController.connect("CrouchChanged", handleCrouchChanged)
	sprintController.connect("SprintChanged", handleSprintChanged)
	pass


func _physics_process(_delta: float) -> void:
	walkController.run(pivotRot.global_transform)
	sprintController.run(player.is_on_floor(), Settings.sprintHoldMode, walkController.state.inputVec, _delta)
	jumpController.run(player.is_on_floor(), _delta)
	crouchController.run(Settings.crouchHoldMode, _delta)
	
	$"../../PivotRot/Camera3D".position.y = crouchController.state.heightOffset
	
	player.velocity = walkController.state.walkVec
	player.velocity *= sprintController.state.speedMultiplier
	player.velocity *= crouchController.state.speedMultiplier
	player.velocity.y = jumpController.state.yMotion
	player.move_and_slide()
	pass


func handleCrouchChanged(_newState: bool) -> void:
	if (_newState): sprintController.actions.changeSprinting.call(false)
	pass


func handleSprintChanged(_newState: bool) -> void:
	if (_newState): crouchController.actions.changeCrouch.call(false)
	pass
