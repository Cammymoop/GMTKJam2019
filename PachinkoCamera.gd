extends Camera2D



# warning-ignore:unused_argument
func _on_Disabler_body_entered(body):
	current = false
	find_parent('Root').find_node('Player').get_node("Camera2D").make_current()
