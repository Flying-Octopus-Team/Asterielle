extends Control

onready var top_text_label = get_node("CanvasLayer/TopText")
onready var center_text_label = get_node("CanvasLayer/CenterText")

var top_text: String = ""
var center_text: String = ""

var time_to_left: float = 0



func init(Time_to_left = 0, Top_text : String = "", Center_text : String = ""):
	time_to_left = Time_to_left
	top_text = Top_text
	center_text = Center_text

func _ready():
	top_text_label.text = top_text
	center_text_label.text = center_text
	
	var timer = Timer.new()
	timer.set_autostart(true)
	timer.set_wait_time(time_to_left)
	timer.connect("timeout", self, "exit")
	add_child(timer)

func exit():
	queue_free()
