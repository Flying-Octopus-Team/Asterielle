extends CheckButton

onready var animation_player = $AnimationPlayer
var active: bool = true

func _ready() -> void:
	connect("toggled", self, "_on_AnimatedCheckButton_toggled")
	
func _on_AnimatedCheckButton_toggled(button_pressed) -> void:
	animate(button_pressed)
 
func set_pressed(value) -> void:
	if !active:
		return
	if pressed != value:
		animate(value)
	pressed = value
	
func animate(on) -> void:
	if on:
		animation_player.play("check_button_on")
	else:
		animation_player.play_backwards("check_button_on")

func set_active(value: bool):
	disabled = !value
	if value == true:
		modulate = Color(1,1,1,1)
		pass
	