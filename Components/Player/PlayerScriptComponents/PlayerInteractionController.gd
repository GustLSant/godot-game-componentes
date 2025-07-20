extends Node
class_name PlayerInteractionController

@export var raycast: RayCast3D
@export var labelDescription: Label
@export var labelActionKey: Label


func _physics_process(_delta: float) -> void:
	raycast.global_transform = Nodes.playerState.currentCameraController.camera.global_transform
	
	if(raycast.is_colliding()):
		var collider: Object = raycast.get_collider().get_parent()
		if(collider is InteractiveObject):
			setLabelsVisible(true)
			labelDescription.text = collider.description
			labelActionKey.text = "Press [" + collider.actionKey + "] to interact"
			collider.checkAction()
		else:
			setLabelsVisible(false)
	else:
		setLabelsVisible(false)
	
	pass


func setLabelsVisible(_visible: bool) -> void:
	labelDescription.visible = _visible
	labelActionKey.visible = _visible
	pass
