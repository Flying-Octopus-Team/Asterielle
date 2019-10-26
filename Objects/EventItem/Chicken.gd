extends "res://Objects/EventItem/EventItem.gd"

var chicken_speed: float = -100

func _ready():
	set_start_position(1100,575)
	move_speed = chicken_speed

func _process(delta):
	move(delta)

func _on_Item_pressed():
	._on_Item_pressed()