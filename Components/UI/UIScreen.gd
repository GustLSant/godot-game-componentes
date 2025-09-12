extends Control
class_name UiScreen

@onready var root: UIRoot = $'..'
var isActive: bool = false : set = setIsActive
var prevScreen: String = ''


func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	setIsActive(root.START_SCREEN == self.name)
	root.connect('ChangeScreen', onChangeScreen)
	pass


func setIsActive(_newValue: bool) -> void:
	self.visible = _newValue
	set_process(_newValue)
	isActive = _newValue
	if(_newValue): onSetActive()
	pass


func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("Return")):
		returnScreen()
	pass


func onChangeScreen(_payload: T_ChangeScreenPayload) -> void:
	handleSetPrevScreen(_payload)
	setIsActive(_payload.nextScreen == self.name)
	pass


func requestChangeScreen(_nextScreen: String, _prevScreen: String = '') -> void:
	var payload: T_ChangeScreenPayload = T_ChangeScreenPayload.new()
	payload.currentScreen = self.name
	payload.nextScreen = _nextScreen
	payload.prevScreen = _prevScreen
	
	root.emit_signal('ChangeScreen', payload)
	pass


func handleSetPrevScreen(_payload: T_ChangeScreenPayload) -> void:
	prevScreen = _payload.prevScreen
	pass


func returnScreen() -> void:
	pass

func onSetActive() -> void:
	pass
