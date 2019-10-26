extends Node

onready var timer = $Timer

var dwarf_in_ballon: bool = false
var event_items : Array = [
	load("res://Objects/EventItem/SackOfGold.tscn"),
	load("res://Objects/EventItem/DwarfInBalloon.tscn"),
	load("res://Objects/EventItem/Chicken.tscn")
]

func _ready():
	restart_timer()

func restart_timer():
	timer.set_wait_time(return_random_time())
	timer.start()

func return_random_time() -> float:
	var value = randi()%40+20
	return value
	
func _on_Timer_timeout():
	spawn_item()

func spawn_item():
	var index : int = randi() % event_items.size()
	var item = event_items[index].instance()
	
	restart_timer()
	
	if item.name == "DwarfInBalloon" && dwarf_in_ballon:
		return
	get_parent().call_deferred("add_child", item)

