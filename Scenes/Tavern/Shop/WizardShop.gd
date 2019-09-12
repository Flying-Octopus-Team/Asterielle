extends "res://Scenes/Tavern/Shop/BasicShop.gd"

onready var speedup_skill = root_node.find_node("SpeedupBtn")

func _ready():
	get_parent().get_parent().connect("room_entered", self, "_on_Room_entered")
	
func _on_Room_entered():
	set_speedup_popup()

func set_speedup_popup():
	var spd_duration = speedup_skill.duration_timer.wait_time
	var popup_title = "Zwieksz czas trwania do " + str(spd_duration+1)
	$SpeedupTimeIncrease.popup_title = popup_title

func _on_SpeedupTimeIncrease_bought():
	speedup_skill.duration_timer.wait_time += 1
	set_speedup_popup()
