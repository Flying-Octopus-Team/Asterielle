extends AudioStreamPlayer

export var looped := true

# How many seconds wait until rep lay on loop
export var replay_delay := 0.0

var fade_in_time := 0.5
var fade_out_time := 0.5

onready var replay_timer : Timer = $ReplayTimer
onready var tween_out : Tween = $FadeTweenOut
onready var tween_in : Tween = $FadeTweenIn

const MIN_VOLUME : float = -80.0
const NORMAL_VOLUME : float = -17.5

signal fade_out_completed
signal fade_in_completed

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

func _on_music_on_changed(on:bool) -> void:
	if on:
		if not playing:
			play()
	else:
		tween_out.stop_all()
		tween_in.stop_all()
		stop()

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
	.play()

func _on_FadeTweenOut_tween_completed(object, key):
	emit_signal("fade_out_completed")

func _on_FadeTweenIn_tween_completed(object, key):
	emit_signal("fade_in_completed")

func fade_out():
	tween_out.interpolate_property(self, "volume_db", NORMAL_VOLUME, MIN_VOLUME, fade_out_time, Tween.TRANS_SINE, Tween.EASE_IN, 0)
	tween_out.start()
	
func fade_in():
	tween_in.interpolate_property(self, "volume_db", MIN_VOLUME, NORMAL_VOLUME, fade_in_time, Tween.TRANS_SINE, Tween.EASE_IN, 0)
	tween_in.start()
	
