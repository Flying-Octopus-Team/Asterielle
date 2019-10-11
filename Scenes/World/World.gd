extends Node2D

#warning-ignore:unused_argument
func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	
