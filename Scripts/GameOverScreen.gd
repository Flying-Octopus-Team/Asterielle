extends Control

signal timeout

onready var game_over_label = find_node("RestartLeftTimer")
onready var left_time_bar = find_node("LeftTimeBar")
onready var timer = find_node("RestartTimer")

func _ready():
	left_time_bar.max_value = ceil(timer.time_left)
	update_label_and_bar()
	
func _process(delta):
	update_label_and_bar()
	
func update_label_and_bar():
	game_over_label.text = str(ceil(timer.time_left))
	left_time_bar.value = ceil(timer.time_left)

func _on_RestartTimer_timeout():
	emit_signal("timeout")
