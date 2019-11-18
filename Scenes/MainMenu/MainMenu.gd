extends Node2D

var world_path = "res://Scenes/World/World.tscn"

func _on_ContinueBtn_pressed():
	get_tree().change_scene(world_path)
