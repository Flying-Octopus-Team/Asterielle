extends "res://Objects/EventItem/EventItem.gd"

var walking_chicken_speed: float = -50

func _ready():
	set_start_position(1100,575)
	move_speed = walking_chicken_speed

func _process(delta):
	move(delta)

func _on_Item_pressed():
	._on_Item_pressed()