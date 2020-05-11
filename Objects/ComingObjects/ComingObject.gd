extends Sprite
class_name ComingObject
signal timeout

export (float) var wait_time = 2

func _ready():
	connect("timeout",self,"_on_timeout")

	$ComingTimer.wait_time = wait_time
	$ComingTimer.start()

func _on_TavernEnterTimer_timeout():
	emit_signal("timeout")
	queue_free()
