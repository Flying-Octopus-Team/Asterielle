extends Sprite

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	print("YUP")