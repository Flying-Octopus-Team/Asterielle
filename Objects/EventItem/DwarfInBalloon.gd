extends "res://Objects/EventItem/EventItem.gd"

onready var event_manager = get_parent().get_node("EventManager")

func _ready():
	event_manager.dwarf_in_ballon = true
	set_start_position(110,400)

func _process(delta):
	move(delta)

func _on_Item_pressed():
	event_manager.dwarf_in_ballon = false
	._on_Item_pressed()