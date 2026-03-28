extends Node

var mainNode: Node3D
var player: Player

# VFX
@onready var goreVfxManager: PoolManager = PoolManager.new("res://Components/VFX/BloodSplash.tscn", 50)
@onready var playerShotVfxManager: PoolManager = PoolManager.new("res://Components/PlayerWeapons/Shot/PlayerShotVfx.tscn", 20)
