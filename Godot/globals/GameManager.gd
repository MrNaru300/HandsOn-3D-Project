extends Node


func _unhandled_key_input(event: InputEvent) -> void:
	var kevent = event as InputEventKey
	match kevent.keycode:
		KEY_ESCAPE:
			get_tree().quit()
