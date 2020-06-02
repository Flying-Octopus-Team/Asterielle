extends Control


onready var music_on_btn : CheckButton = find_node("MusicOnBtn")
onready var sounds_on_btn : CheckButton = find_node("SoundsOnBtn")


func _ready() -> void:
	music_on_btn.set_pressed_without_animation(Settings.music_on)
	sounds_on_btn.set_pressed_without_animation(Settings.sounds_on)

	music_on_btn.connect("toggled", self, "_on_music_on_btn_toggled")
	sounds_on_btn.connect("toggled", self, "_on_sounds_on_btn_toggled")


func _on_music_on_btn_toggled(pressed:bool) -> void:
	Settings.music_on = pressed


func _on_sounds_on_btn_toggled(pressed:bool) -> void:
	Settings.sounds_on = pressed
