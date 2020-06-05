extends Node

signal sounds_on_changed(on)
signal music_on_changed(on)

var sounds_on := true setget set_sounds_on
var music_on := true setget set_music_on

const save_file_path := "user://settings.json"


func _init() -> void:
	load_from_file()


func set_sounds_on(on:bool) -> void:
	sounds_on = on
	save()
	emit_signal("sounds_on_changed", on)


func set_music_on(on:bool) -> void:
	music_on = on
	save()
	emit_signal("music_on_changed", on)


func load_from_file() -> void:
	var file = File.new()
	
	if not file.file_exists(save_file_path):
		return
	
	file.open(save_file_path, File.READ)
	
	var save_dict = JSON.parse(file.get_as_text()).result
	
	sounds_on = save_dict["sounds_on"]
	music_on = save_dict["music_on"]
	
	file.close()


func save() -> void:
	var file = File.new()
	file.open(save_file_path, File.WRITE)
	
	var save_dict = {
		"sounds_on": sounds_on,
		"music_on": music_on
	}
	
	file.store_line(JSON.print(save_dict))
	
	file.close()
