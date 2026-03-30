class_name PlayerMovementContext
extends Node

@export var walkController: WalkController
@export var sprintController: SprintController

@export var player: CharacterBody3D
@export var pivotRot: Node3D


func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	walkController.run(pivotRot.global_transform)
	sprintController.run(player.is_on_floor(), Settings.sprintHoldMode, walkController.state.inputVec, _delta)
	
	player.velocity = walkController.state.walkVec
	player.velocity *= sprintController.state.speedMultiplier
	player.move_and_slide()
	pass
