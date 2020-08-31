extends Node2D

func _ready() -> void:
	GameData.setup()
	GameLoader.setup()
	GameSaver.setup()
	
	MusicManager.switch_music(MusicManager.Musics.GAMEPLAY_MUSIC)
	$MainObjectsLayer/Elf.connect("game_over", self, "_on_game_over")

#warning-ignore:unused_argument
func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE) && OS.get_name() != "HTML5":
		get_tree().quit()


func _on_game_over() -> void:
	if Settings.sounds_on:
		$GameOverSound.play()
