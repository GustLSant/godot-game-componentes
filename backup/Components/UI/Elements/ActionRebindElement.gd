extends Control
class_name ActionRebindElement

@onready var label: Label = $HBoxContainer/Label
@onready var button: Button = $HBoxContainer/Button

var action: String = 'Jump'
var actionText: String = 'Jump'
var isWaitingForInput: bool = false


func _ready() -> void:
	label.text = actionText
	button.text = InputMap.action_get_events(action)[0].as_text()
	button.connect("pressed", onPressed)
	pass


func onPressed() -> void:
	isWaitingForInput = true
	button.text = '...'
	pass


func _unhandled_input(event: InputEvent):
	if isWaitingForInput and event.is_pressed():
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
	
		button.text = event.as_text()
	
		isWaitingForInput = false
