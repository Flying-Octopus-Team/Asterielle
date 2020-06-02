extends AudioStreamPlayer

export var fade_in := true
export var fade_out := true

export var fade_in_time := 0.5
export var fade_out_time := 0.5

export var looped := true

# How many seconds wait until rep lay on loop
export var replay_delay := 0.0

onready var replay_timer : Timer = $ReplayTimer
onready var tween : Tween = $FadeTween

const MIN_VOLUME : float = -80.0
const NORMAL_VOLUME : float = 0.0


func _init() -> void:
	if not Settings.music_on:
		stop()
		autoplay = false


func _ready() -> void:
	Settings.connect("music_on_changed", self, "_on_music_on_changed")
	connect("finished", self, "_on_music_finished")
	replay_timer.connect("timeout", self, "_on_replay_timer_timeout")
	
	if not Settings.music_on:
		stop()
		return
	
	_prepare_tween()


func _prepare_tween() -> void:
	if fade_in:
		fade_in()
	
	if fade_out:
		fade_out()


func _on_music_on_changed(on:bool) -> void:
	if on:
		if not playing:
			play()
	else:
		stop()


func fade_in() -> void:
	_fade_volume(MIN_VOLUME, NORMAL_VOLUME, Tween.TRANS_EXPO, fade_in_time)


func fade_out() -> void:
	var delay : float = stream.get_length() - fade_out_time 
	_fade_volume(NORMAL_VOLUME, MIN_VOLUME, fade_out_time, Tween.TRANS_LINEAR, delay)


func _fade_volume(from:float, to:float, duration:float, trans_type:int, delay:float=0.0) -> void:
	tween.interpolate_property(self, "volume_db", from, to, duration, trans_type, Tween.EASE_OUT, delay)
	tween.start()


func _on_music_finished() -> void:
	if not Settings.music_on:
		return
	
	if looped:
		replay_timer.start(replay_delay)


func _on_replay_timer_timeout() -> void:
	if looped:
		play()


func play(from_position:float=0.0) -> void:
	if not Settings.music_on:
		return
	
	_prepare_tween()
	.play()
