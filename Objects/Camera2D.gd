extends Camera2D

func _process(delta):
	self.position.x += BackgroundData.move_speed * delta
