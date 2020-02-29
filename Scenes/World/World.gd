extends Node2D

func _ready() -> void:
	GameData.setup()
	
	var game_saver = find_node("GameSaver")
	game_saver.setup()

#warning-ignore:unused_argument
func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
