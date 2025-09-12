extends UiScreen

@export var container: VBoxContainer

var actions: Array[String] = [
	'MoveForward',
	'MoveLeft',
	'MoveBackward',
	'MoveRight',
	'Interact',
	'Reload',
	'Sprint',
	'Jump',
	'Crouch',
	'InspectWeapon',
	'ToggleDevice_L',
	'ToggleDevice_M',
	'ToggleDevice_R',
]

var actionsText: Array[String] = [
	'Move Forward',
	'Move Left',
	'Move Backward',
	'Move Right',
	'Interact',
	'Reload Weapon',
	'Sprint',
	'Jump',
	'Crouch',
	'Inspect Weapon',
	'Toggle Left Device',
	'Toggle Middle Device',
	'Toggle Right Device',
]


func _ready() -> void:
	super._ready()
	
	for i in range(actions.size()):
		var element: ActionRebindElement = load("res://Components/UI/Elements/ActionRebindElement.tscn").instantiate()
		element.action = actions[i]
		element.actionText = actionsText[i]
		container.add_child(element)
		pass
	
	pass


func returnScreen() -> void:
	requestChangeScreen('Settings')
	pass


func _on_return_button_pressed() -> void:
	returnScreen()
	pass
