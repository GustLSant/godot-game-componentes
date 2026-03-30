extends Control
class_name UiScreen

@onready var root: UIRoot = $'..'
@export var prevScreen: String = ''
var isActive: bool = false : set = setIsActive


func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	setIsActive(root.START_SCREEN == self.name)
	root.connect('ChangeScreen', onChangeScreen)
	pass


func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("Return")):
		returnToPrevScreen()
	pass


func setIsActive(_newValue: bool) -> void:
	isActive = _newValue
	self.visible = _newValue
	set_process(_newValue)
	if(_newValue): onSetActive()
	pass


func onChangeScreen(_nextScreen: String, _prevScreen: String) -> void:
	setIsActive(_nextScreen == self.name)
	if (isActive): prevScreen = _prevScreen
	pass


func returnToPrevScreen() -> void:
	root.emit_signal('ChangeScreen', prevScreen, self.name)
	pass


# override
func onSetActive() -> void:
	pass
