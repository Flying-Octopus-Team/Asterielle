extends Control

signal timeout

onready var top_text_label = get_node("CanvasLayer/TopText")
onready var icon_sprite = get_node("CanvasLayer/Sprite")
onready var center_text_label = get_node("CanvasLayer/CenterText")
onready var game_manager = get_parent().get_node("GameManager")

var top_text: String = ""
var center_text: String = ""
var icon_anim_name = "moon"

var time_to_left: float = 0

onready var anim = get_node("AnimationPlayer")



func init(Time_to_left = 0, Top_text : String = "", Center_text : String = "", Icon_anim_name = "skull"):
	time_to_left = Time_to_left
	top_text = Top_text
	center_text = Center_text
	icon_anim_name = Icon_anim_name

func _ready():
	game_manager.stop_gameplay();
	anim.play("FadedIn")
	top_text_label.text = top_text
	center_text_label.text = center_text
	icon_sprite.play(icon_anim_name)

func _on_ExitButton_pressed():
	anim.play("FadedOut")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadedOut":
		game_manager.resume_gameplay();
		emit_signal("timeout")
		queue_free()