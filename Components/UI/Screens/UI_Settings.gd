extends UiScreen


func handleSetPrevScreen(_payload: T_ChangeScreenPayload) -> void:
	if(_payload.prevScreen == 'MainMenu' or _payload.prevScreen == 'PauseMenu'):
		prevScreen = _payload.prevScreen
	pass


func returnScreen() -> void:
	if(prevScreen == 'MainMenu'): requestChangeScreen('MainMenu')
	elif(prevScreen == 'PauseMenu'): requestChangeScreen('PauseMenu')
	else: printerr('Settings doesnt have a prevScreen')
	pass


func _on_rebinding_menu_pressed() -> void:
	requestChangeScreen('ActionRebindingMenu')
	pass


func _on_return_button_pressed() -> void:
	returnScreen()
	pass
