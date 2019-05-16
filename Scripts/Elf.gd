extends Node2D

export(float) var arrow_speed;
export(float) var next_arrow_wait_time

var fire_point : Node2D
var Arrow = load("res://Scenes/Arrow.tscn")
var next_arrow_timer : float

func _ready():
	restart_arrow_timer()
	fire_point = find_node("FirePoint")
	
func _process(delta):
	next_arrow_timer -= delta
	
	if next_arrow_timer <= 0:
		shot_arrow()

func _input(event):
	if Input.is_action_just_pressed("faster_shot"):
		next_arrow_timer -= 0.1
				
func shot_arrow():
	restart_arrow_timer()
	
	var arrow = Arrow.instance()
	get_parent().add_child(arrow);
	arrow.global_position = fire_point.global_position
	arrow.velocity = Vector2(arrow_speed, 0)

func restart_arrow_timer():
	next_arrow_timer = next_arrow_wait_time