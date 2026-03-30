extends Control
class_name UIRoot

@export var START_SCREEN: String = 'MainMenu'
signal ChangeScreen(_nextScreen: String, _prevScreen: String)
