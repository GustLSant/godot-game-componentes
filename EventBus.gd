class_name EventBus
extends RefCounted

var events: Dictionary = {}


func subscribe(_eventName: String, _callback: Callable) -> void:
	var eventExists: bool = events.has(_eventName)
	
	if (not eventExists):
		events[_eventName] = []
	
	var currentCallbackList: Array[Callable] = events[_eventName]
	var callbackExistsInList: bool = currentCallbackList.has(_callback)
	
	if (not callbackExistsInList):
		currentCallbackList.append(_callback)
	return


func unsubscribe(_eventName: String, _callback: Callable) -> void:
	var callbackExistsInList: bool = events.has(_eventName)
	
	if (callbackExistsInList):
		var currentCallbackList: Array[Callable] = events[_eventName]
		currentCallbackList.erase(_callback)
	return


func emit(_eventName: String, _args = null) -> void:
	var eventExists: bool = events.has(_eventName)
	
	if (not eventExists):
		return
	
	var currentCallbackList: Array[Callable] = events[_eventName]
	
	for cllbck in currentCallbackList:
		if _args == null: cllbck.call()
		else: cllbck.call(_args)
	return
