class_name PlayerMovementHandler
extends Node

@export var context: PlayerContext
@export var player: CharacterBody3D


func _ready() -> void:
	context.crouchController.connect("CrouchChanged", handleCrouchChanged)
	context.sprintController.connect("SprintChanged", handleSprintChanged)
	pass


func _physics_process(_delta: float) -> void:
	player.velocity = context.fpsWalkController.state.walkVec
	player.velocity *= context.sprintController.state.speedMultiplier
	player.velocity *= context.crouchController.state.speedMultiplier
	player.velocity.y = context.jumpController.state.yMotion
	player.move_and_slide()
	pass


func handleCrouchChanged(_newState: bool) -> void:
	if (_newState): context.sprintController.actions.changeSprinting.call(false)
	pass


func handleSprintChanged(_newState: bool) -> void:
	if (_newState): context.crouchController.actions.changeCrouch.call(false)
	pass
