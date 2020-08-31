extends Node

export var main_menu_music : AudioStream
export var tavern_music : AudioStream
export var gameplay_music : AudioStream

var current_music = Musics.MAIN_MENU_MUSIC

enum Musics {
	MAIN_MENU_MUSIC = 1,
	TAVERN_MUSIC = 2,
	GAMEPLAY_MUSIC = 3
}

func _ready():
	main_menu_music = ResourceLoader.load("res://Music/menu_music.wav")
	tavern_music = ResourceLoader.load("res://Music/Asterielle Tawerna.wav")
	gameplay_music = ResourceLoader.load("res://Music/game_music.wav")

func switch_music_without_fade(music):
	set_music(music)
	$MusicPlayer.play()


func set_music(music):
	match music:
		Musics.MAIN_MENU_MUSIC:
			$MusicPlayer.stream = main_menu_music
		Musics.TAVERN_MUSIC:
			$MusicPlayer.stream = tavern_music
		Musics.GAMEPLAY_MUSIC:
			$MusicPlayer.stream = gameplay_music


func switch_music(new_music, fade_out_time : float = 4.0, fade_in_time : float = 3.0):
	$MusicPlayer.fade_out_time = fade_out_time
	$MusicPlayer.fade_in_time = fade_in_time
	$MusicPlayer.fade_out()
	current_music = new_music

func _on_MusicPlayer_fade_out_completed():
	set_music(current_music)
	$MusicPlayer.fade_in()
	if(!$MusicPlayer.playing):
		$MusicPlayer.play()
