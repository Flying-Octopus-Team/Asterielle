extends TextureButton

signal used
signal ready_changed
signal using_changed
signal finished

export(bool) var instant_efect = true

# cd - CoolDown
onready var cd_texture = $CooldownTexture
onready var cd_timer = $CooldownTimer
onready var time_left_label = $TimeLeftLabel
onready var duration_timer = $DurationTimer

var ready : bool = true setget set_ready, is_ready
var using : bool = false setget set_using, is_using
	
func _ready() -> void:
	var tavern = get_node("/root/World").find_node("TavernScreen")
	tavern.connect("tavern_entered", self, "_on_Tavern_entered")
	tavern.connect("tavern_exited", self, "_on_Tavern_exited")
	
func _on_Tavern_entered() -> void:
	ready = false
	
func _on_Tavern_exited() -> void:
	ready = true
	
func _process(delta) -> void:
	if ready:
		return
	
	var time_left : float
	
	if using:
		time_left = duration_timer.time_left
	else:
		time_left = cd_timer.time_left
		cd_texture.value = time_left / cd_timer.wait_time
	
	if time_left > 60:
		time_left_label.text = str(ceil(time_left / 60)) + " min"
	elif time_left > 0:
		time_left_label.text = str(ceil(time_left)) + " sec"

func use() -> void:
	ready = false
	mouse_default_cursor_shape = Control.CURSOR_ARROW
	
	if instant_efect:
		finish()
	else:
		using = true
		duration_timer.start()
	
	emit_signal("used")
	
func finish() -> void:
	cd_timer.start()
	using = false
	emit_signal("finished")

func _on_CooldownTimer_timeout() -> void:
	ready = true
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	time_left_label.text = ""
 
func _on_SkillBtn_pressed():
	if ready:
		use()

func set_ready(value:bool) -> void:
	ready = value
	emit_signal("ready_changed")
	
func is_ready() -> bool:
	return ready
	
func set_using(value:bool) -> void:
	using = value
	emit_signal("using_changed")
	
func is_using() -> bool:
	return using

func _on_DurationTimer_timeout():
	finish()
	
func disable():
	disabled = true
	mouse_default_cursor_shape = Control.CURSOR_ARROW
	
func enable():
	disabled = false
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
