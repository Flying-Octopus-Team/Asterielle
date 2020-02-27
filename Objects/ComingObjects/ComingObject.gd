extends Sprite
class_name ComingObject
signal timeout

func _ready():
	connect("timeout",self,"_on_timeout")
	
	var cam_pos = get_node("/root/World").find_node("Camera2D").position
	var diff = get_viewport_rect().size.x
	$ComingTimer.wait_time = diff / BackgroundData.move_speed
	$ComingTimer.start()

func _on_TavernEnterTimer_timeout():
	emit_signal("timeout")
	queue_free()

func _on_timeout():
	pass
