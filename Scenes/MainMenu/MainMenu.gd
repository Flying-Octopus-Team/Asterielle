extends Node2D

var world_path = "res://Scenes/World/World.tscn"

func _on_ContinueBtn_pressed():
	get_tree().change_scene(world_path)


func _on_NewGameBtn_pressed():
	get_tree().change_scene(world_path)
	get_tree().find_node("GameSaver").hard_reset()


func _on_OptionsBtn_pressed():
	pass # Replace with function body.


func _on_AboutBtn_pressed():
	pass # Replace with function body.


func _on_ExitBtn_pressed():
	get_tree().quit()
