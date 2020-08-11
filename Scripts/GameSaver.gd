extends Node

const SAVE_PATH = "user://save.json"
var timer

func setup():
	if(timer != null):
		timer.start(1)
		return
		
	timer = Timer.new()
	add_child(timer)
	timer.start(1)
	timer.connect("timeout", self, "_on_NextSaveTimer_timeout")

func stop_timer():
	if(timer != null):
		timer.stop()
		return

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
