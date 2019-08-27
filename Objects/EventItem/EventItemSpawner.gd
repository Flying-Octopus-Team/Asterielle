extends Node

var time_to_spawn_item: float = 5
var temp_time: float = 0
var SackOfGold = load("res://Objects/EventItem/SackOfGold.tscn")
var DwarfInBalloon = load("res://Objects/EventItem/DwarfInBalloon.tscn")

func set_next_item_time():
	var value = randi()%60+20
	time_to_spawn_item = value 
	temp_time = 0

func spawn_item():
	var index: int = randi()%2+1 
	if index == 1:
		var sof = SackOfGold.instance()
		get_parent().call_deferred("add_child", sof)
	else:
		var din = DwarfInBalloon.instance()
		get_parent().call_deferred("add_child", din)

func _process(delta):
	temp_time += delta
	
	if temp_time >= time_to_spawn_item:
		spawn_item()
		set_next_item_time()