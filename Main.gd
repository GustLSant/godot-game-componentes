extends Node3D


func _init() -> void:
	Nodes.mainNode = self
	pass

func _ready() -> void:
	print("A fazer: ")
	print("- Padronizar os sinais dos states:")
	print("  - Imperativo (ChangeWeapon): sinal para um node fazer algo imediatamente")
	print("  - Pretérito (WeaponChanged): sinal para os nodes reagirem à mudança")
	print("")
	pass

#func _process(_delta:float)->void:
	#if(Input.is_action_just_pressed("ui_cancel")): get_tree().quit()
	#pass
