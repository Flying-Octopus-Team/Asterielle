extends Node

const SAVE_PATH = "res://save.json"


func save_game():
	var save_dict = GameLoader.load_player_data()
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)
	save_file.store_line(to_json(save_dict))
	save_file.close()

func hard_reset():
	GameLoader.revival_reset()
	GameLoader.load_silver_moon(0)
	save_game()

func _on_NextSaveTimer_timeout():
	save_game()
