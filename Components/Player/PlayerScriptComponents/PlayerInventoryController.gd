extends Node
class_name PlayerInventoryController


func _ready() -> void:
	PlayerState.connect("TryPickupWeapon", onTryPickupWeapon)
	pass


func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("ChangeNextWeapon")):
		PlayerState.emit_signal("WeaponChanged", 0)


func onTryPickupWeapon(_newWeaponScenePath: String) -> void:
	if(PlayerState.inventory.size() < PlayerState.inventoryMaxSize):
		var newWeapon: Node3D = load(_newWeaponScenePath).instantiate()
		PlayerState.inventory.append(newWeapon)
		Nodes.playerFpsArmsWeaponsSocket.add_child(newWeapon)
		print('on try pickup weapon: ', newWeapon)
	pass
