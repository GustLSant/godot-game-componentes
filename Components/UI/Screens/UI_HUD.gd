extends UiScreen


func returnScreen() -> void:
	GameplayManager.emit_signal('PauseGame')
	requestChangeScreen('PauseMenu')
	pass
