extends Node
class_name T_StartInventory

var weapons: Array[String] = []
var weaponAttachments: Array[T_StartWeaponAttachmentLoadout] = []
var reserveAmmo: Array = [0, 0, 0, 0]        # cada indice eh um tipo de municao
var keyItems: Array = []
var misc: Array = []
