extends Node

var currentLevel: Node3D = null

signal StartGame()
signal GameStarted()
signal PauseGame()
signal ResumeGame()
signal QuitGame()

var startInventory: T_StartInventory = T_StartInventory.new()


func _init() -> void:
	self.connect('StartGame', onStartGame)
	self.connect('GameStarted', onGameStarted)
	self.connect('PauseGame', onPauseGame)
	self.connect('ResumeGame', onResumeGame)
	self.connect('QuitGame', onQuitGame)
	pass


func _ready() -> void:
	var attLoadout_01: T_StartWeaponAttachmentLoadout = T_StartWeaponAttachmentLoadout.new()
	#attLoadout_01.paths[T_AttachmentSlot.ENUM.SIGHT] = "res://Components/PlayerWeapons/Attachments/RedDotSight.tscn"
	#attLoadout_01.paths[T_AttachmentSlot.ENUM.SIGHT] = "res://Components/PlayerWeapons/Attachments/ScopeSight.tscn"
	#attLoadout_01.paths[T_AttachmentSlot.ENUM.MAGAZINE] = "res://Components/PlayerWeapons/Attachments/DrumMagazine.tscn"
	#attLoadout_01.paths[T_AttachmentSlot.ENUM.GRIP] = "res://Components/PlayerWeapons/Attachments/LongGrip.tscn"
	attLoadout_01.paths[T_AttachmentSlot.ENUM.DEVICE_R] = "res://Components/PlayerWeapons/Attachments/RedLaserDevice.tscn"
	#attLoadout_01.paths[T_AttachmentSlot.ENUM.DEVICE_L] = "res://Components/PlayerWeapons/Attachments/FlashlightDevice.tscn"
	#attLoadout_01.paths[T_AttachmentSlot.ENUM.BARREL] = "res://Components/PlayerWeapons/Attachments/SilencerBarrel.tscn"
	
	var attLoadout_02: T_StartWeaponAttachmentLoadout = T_StartWeaponAttachmentLoadout.new()
	#attLoadout_02.paths[T_AttachmentSlot.ENUM.SIGHT] = "res://Components/PlayerWeapons/Attachments/ScopeSight.tscn"
	#attLoadout_02.paths[T_AttachmentSlot.ENUM.SIGHT] = "res://Components/PlayerWeapons/Attachments/RedDotSight.tscn"
	attLoadout_02.paths[T_AttachmentSlot.ENUM.DEVICE_M] = "res://Components/PlayerWeapons/Attachments/RedLaserDevice.tscn"
	
	startInventory.weapons = [
		"res://Components/PlayerWeapons/Weapon_04.tscn",
		"res://Components/PlayerWeapons/Weapon_01.tscn"
	]
	startInventory.weaponAttachments = [attLoadout_01, attLoadout_02]
	
	startInventory.reserveAmmo = [50, 0, 200, 0]
	pass


func onStartGame() -> void:
	currentLevel = load("res://Levels/TestingLevel.tscn").instantiate()
	Nodes.mainNode.add_child(currentLevel)
	Nodes.mainNode.move_child(currentLevel, 0)
	emit_signal('GameStarted')
	pass


func onGameStarted() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass


func onPauseGame() -> void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pass


func onResumeGame() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass


func onQuitGame() -> void:
	currentLevel.queue_free()
	pass
