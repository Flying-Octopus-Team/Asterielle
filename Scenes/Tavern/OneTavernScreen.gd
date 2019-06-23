extends Control

signal room_exited

func _ready():
	connect("room_exited", get_parent(), "_on_Room_exited")

func on_enter():
	visible = true
	
func _on_ExitBtn_pressed():
	visible = false
	emit_signal("room_exited")