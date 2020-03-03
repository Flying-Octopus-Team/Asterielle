extends Node2D

export(int) var gold_reward = 65
export(float) var move_speed = -100

func _ready():
	var value = randi()%800+160
	set_start_position(value,293)

func _process(delta):
	move(delta)
	
func move(delta):
	position.x += move_speed * delta

func set_start_position(x, y):
	position.x = x
	position.y = y

func get_reward():
	GameData.gold += gold_reward

func _on_Item_pressed():
	get_reward()
	queue_free()
