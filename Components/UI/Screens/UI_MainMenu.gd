extends UiScreen


func _init() -> void:
	GameplayManager.connect('GameStarted', onGameStarted)
	pass


func _on_play_btn_pressed() -> void:
	GameplayManager.emit_signal('StartGame')
	pass


func _on_settings_button_pressed() -> void:
	requestChangeScreen('Settings', self.name)
	pass


func onGameStarted() -> void:
	requestChangeScreen('HUD')
	pass
