extends Area2D
class_name InteractionAreaComponent

@export var action_name : String = 'Interact'

var interact : Callable = func():
	pass

func toggle_disable(switch : bool):
	get_child(0).disabled = switch

func _on_area_entered(_area):
	InteractionManager.register_area(self)

func _on_area_exited(_area):
	InteractionManager.unregister_area(self)
