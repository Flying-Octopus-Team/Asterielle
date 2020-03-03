extends "res://Objects/EventItem/EventItem.gd"

func _ready():
	set_start_position(600, 293)

func _process(delta):
	position.x += move_speed * delta

func _on_Item_pressed():
	get_reward()
	queue_free()
