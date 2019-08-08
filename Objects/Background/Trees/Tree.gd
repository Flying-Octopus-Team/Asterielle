extends Sprite

func _ready():
	var flip: int = randi()%2+1 
	if flip == 1:
		flip_h = false
	else:
		flip_h = true
	print(flip)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()