extends CheckButton

onready var animation_player = $AnimationPlayer
var active: bool = true

# Region position for pressed / released
const region_pos = {
	true: Vector2(61, 67),
	false: Vector2(61, 187)
}


func _ready() -> void:
	connect("toggled", self, "_on_AnimatedCheckButton_toggled")


func _on_AnimatedCheckButton_toggled(button_pressed) -> void:
	animate(button_pressed)
	
	if Settings.sounds_on:
		$ToggleSound.play()


func set_pressed_without_animation(value:bool) -> void:
	pressed = value
	$Sprite.region_rect.position = region_pos[pressed]


func set_pressed(value) -> void:
	if pressed != value:
		pressed = value
		animate(value)


func animate(on) -> void:
	if on:
		animation_player.play("check_button_on")
	else:
		animation_player.play_backwards("check_button_on")


func set_active(value: bool):
	disabled = !value
	visible = value
