extends Node

var timer = null
var event_items : Array = [
	load("res://Objects/EventItem/SackOfGold.tscn"),
	load("res://Objects/EventItem/DwarfInBalloon.tscn")
]

func _ready():
	wait_to_spawn_item()

func wait_to_spawn_item():
	timer = Timer.new()
	timer.set_wait_time(return_random_time())
	timer.connect("timeout",self,"spawn_item")
	add_child(timer)
	timer.start()

func return_random_time() -> float:
	var value = randi()%40+20
	return value

func spawn_item():
	var index : int = randi() % event_items.size()
	var item = event_items[index].instance()
	get_parent().call_deferred("add_child", item)