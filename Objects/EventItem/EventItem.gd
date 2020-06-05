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
	
	queue_free()
	
func _input(event):
	if (event is InputEventMouseButton) and event.pressed:
		var evLocal = make_input_local(event)
		if $Sprite.get_rect().has_point(evLocal.position):
			_on_Item_pressed()

func _on_screen_exited():
	queue_free()
