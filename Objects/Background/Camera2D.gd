extends Camera2D

func _ready():
	pass # Replace with function body.

func _process(delta):
	self.position.x += BackgroundData.move_speed * delta
