extends "res://Objects/EventItem/EventItem.gd"

func _process(delta):
	position.x += move_speed * delta
