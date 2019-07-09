extends Control

onready var top_text_label = get_node("CanvasLayer/TopText")
onready var center_text_label = get_node("CanvasLayer/CenterText")

var time_to_left: float = 0
var top_text: String = ""
var center_text: String = ""

func init(Time_to_left = 0, Top_text : String = "", Center_text : String = ""):
	time_to_left = Time_to_left
	top_text = Top_text
	center_text = Center_text

func _ready():
	top_text_label.text = top_text
	center_text_label.text = center_text

func _on_ExitButton_pressed():
	queue_free()

func _process(delta):
	time_to_left -= delta
	if time_to_left > 0:
		return
	queue_free()
