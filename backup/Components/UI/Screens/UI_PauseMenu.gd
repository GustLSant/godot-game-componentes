extends UiScreen


func returnScreen() -> void:
	GameplayManager.emit_signal('ResumeGame')
	requestChangeScreen('HUD')
	pass


func _on_resume_btn_pressed() -> void:
	GameplayManager.emit_signal('ResumeGame')
	requestChangeScreen('HUD')
	pass


func _on_settings_btn_pressed() -> void:
	requestChangeScreen('Settings', self.name)
	pass


func _on_quit_button_pressed() -> void:
	requestChangeScreen('MainMenu')
	GameplayManager.emit_signal('QuitGame')
	pass
