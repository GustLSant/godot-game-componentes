extends Object
class_name T_WeaponPickupRequest

var newWeapon: PlayerWeapon = null
var isReplacement: bool = false
var weaponPickup: WeaponPickup = null


func printData() -> void:
	print("### T_WeaponPickupRequest ###")
	print("Instance: ", self)
	print("newWeapon: ", newWeapon)
	print("isReplacement: ", isReplacement)
	print("weaponPickup: ", weaponPickup)
	print("")
	pass
