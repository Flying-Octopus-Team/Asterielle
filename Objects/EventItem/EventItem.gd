extends Node2D

export(int) var gold_reward = 65
export(float) var move_speed = 100
export(Vector2) var start_position = Vector2()



func _ready():
	var value = randi()%800+160
	set_start_position(value,550)

func _process(delta):
	move(delta)
	
func move(delta):
	position.x -= move_speed * delta

func set_start_position(var x, var y):
	position.x = x
	position.y = y

func get_reward():
	pass

func _on_Item_pressed():
	get_reward()
	queue_free()