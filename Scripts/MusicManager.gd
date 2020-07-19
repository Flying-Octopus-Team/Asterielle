extends Node2D

export var main_menu_music : AudioStream
export var tavern_music : AudioStream
export var gameplay_music : AudioStream



func _ready():
	play_music(Musics.GAMEPLAY_MUSIC)

func play_music(music):
	match music:
		Musics.MAIN_MENU_MUSIC:
			$MusicPlayer.stream = main_menu_music
		Musics.TAVERN_MUSIC:
			$MusicPlayer.stream = tavern_music
		Musics.GAMEPLAY_MUSIC:
			$MusicPlayer.stream = gameplay_music
	$MusicPlayer.play()

enum Musics {
	MAIN_MENU_MUSIC = 1,
	TAVERN_MUSIC = 2,
	GAMEPLAY_MUSIC = 3
}
