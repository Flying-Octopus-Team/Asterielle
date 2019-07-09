extends Node2D

onready var game_manager = get_parent().get_node("GameManager")

func _ready():
	game_manager.stop_gameplay()

func _on_Button_pressed():
	game_manager.resume_gameplay()
	queue_free()
