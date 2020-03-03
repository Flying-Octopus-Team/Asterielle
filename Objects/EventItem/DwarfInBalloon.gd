extends "res://Objects/EventItem/EventItem.gd"

onready var event_manager = get_parent().get_node("EventManager")

func _ready():
	event_manager.dwarf_in_ballon = true
	set_start_position(100, 110)

func _on_Item_pressed():
	event_manager.dwarf_in_ballon = false
	get_reward()
	queue_free()
