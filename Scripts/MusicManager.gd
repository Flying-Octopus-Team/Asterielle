extends Node2D

export var main_menu_music : AudioStream
export var tavern_music : AudioStream
export var gameplay_music : AudioStream



enum Musics {
	MAIN_MENU_MUSIC = 1,
	TAVERN_MUSIC = 2,
	GAMEPLAY_MUSIC = 3
}

enum FadedSpeed{
	FAST = 250,
	NORMAL = 500,
	SLOW = 1000
}

func _ready():
	main_menu_music = ResourceLoader.load("res://Music/menu_music.wav")
	tavern_music = ResourceLoader.load("res://Music/Asterielle Tawerna.wav")
	gameplay_music = ResourceLoader.load("res://Music/game_music.wav")

func switch_music(music):
	match music:
		Musics.MAIN_MENU_MUSIC:
			$MusicPlayer.stream = main_menu_music
		Musics.TAVERN_MUSIC:
			$MusicPlayer.stream = tavern_music
		Musics.GAMEPLAY_MUSIC:
			$MusicPlayer.stream = gameplay_music
	$MusicPlayer.play()

func switch_music_with_fade(new_music, faded_speed = FadedSpeed.NORMAL):
	var milisecond = int(faded_speed)
	#TODO: Finish
	pass
