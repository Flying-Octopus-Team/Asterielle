extends "res://Objects/EventItem/EventItem.gd"

func _ready():
	set_start_position(110,400)

func _process(delta):
	move(-delta)
