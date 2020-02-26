extends Sprite
class_name ComingObject
signal timeout

func _ready():
	connect("timeout",self,"_on_timeout")
	
	var cam_pos = get_node("/root/World").find_node("Camera2D").position
	print(cam_pos.x)
	print(position.x)
	var diff = get_viewport_rect().size.x
	$ComingTimer.wait_time = diff / BackgroundData.move_speed
	$ComingTimer.start()

func _physics_process(delta): #unnecesary since camera2D was added
	#position.x += BackgroundData.move_speed * delta * 2
	pass

func _on_TavernEnterTimer_timeout():
	emit_signal("timeout")
	queue_free()

func _on_timeout():
	pass
