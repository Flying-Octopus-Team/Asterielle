extends Control

var time_to_end = 10.0

func _process(delta):
	time_to_end -= delta
	if time_to_end > 0:
		return
	queue_free()

func _on_Button_pressed():
	queue_free()
