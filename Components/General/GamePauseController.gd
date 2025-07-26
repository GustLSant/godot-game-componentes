extends Control


func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	setPause(false)
	pass


func _input(_event: InputEvent) -> void:
	if(Input.is_action_just_pressed("Pause")):
		setPause(not get_tree().paused)
	pass


func setPause(_value: bool) -> void:
	get_tree().paused = _value
	self.visible = _value
	if(_value): Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass


func _on_resume_button_pressed() -> void:
	setPause(false)
	pass


func _on_quit_button_pressed() -> void:
	get_tree().quit()
	pass
