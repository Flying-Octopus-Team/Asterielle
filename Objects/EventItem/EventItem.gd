extends Node2D

const SPAWN_Y = 260
const SPAWN_X = 800
export(int) var gold_reward = 65
export(float) var move_speed = -100
onready var cam_pos = get_node("/root/World").find_node("Camera2D").position

var taken := false

func _ready():
	set_start_position(SPAWN_X, SPAWN_Y)

func _process(delta):
	position.x += move_speed * delta

func set_start_position(x, y):
	position.x = cam_pos.x + x
	position.y = y

func get_reward():
	GameData.gold += gold_reward
	
	taken = true
	

func _on_Item_pressed():
	if taken:
		return
	
	get_reward()
	
	if not Settings.sounds_on:
		queue_free()
		return
	
	$PrizeSound.play()
	hide()
	
	yield($PrizeSound, "finished")
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	queue_free()

func _on_screen_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	queue_free()

func _on_Area2D_mouse_entered():
	$Highlight.visible = true
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_Area2D_mouse_exited():
	$Highlight.visible = false
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	

func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton) and event.pressed:
		_on_Item_pressed()
