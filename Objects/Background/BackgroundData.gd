extends Node

var normal_speed: float = 70
var fast_speed: float = 140

var move_speed: float = 70

func change_to_fast_speed():
	move_speed = fast_speed
	var back_to_normal_timer = Timer.new()
	back_to_normal_timer.connect("timeout", self, "change_back_to_normal")
	back_to_normal_timer.set_name("Timer")
	add_child(back_to_normal_timer)
	back_to_normal_timer.start(4)
	
func change_back_to_normal():
	move_speed = normal_speed
	$Timer.queue_free()
