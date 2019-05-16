extends KinematicBody2D

export(float) var arrow_speed = 10.0;

var fire_point : Node2D
var Arrow = load("res://Scenes/Arrow.tscn")

func _ready():
	fire_point = find_node("FirePoint")
	
func _process(delta):
	pass

func _on_NextArrowTimer_timeout():
	var arrow = Arrow.instance()
	get_parent().add_child(arrow);
	arrow.global_position = fire_point.global_position
	arrow.velocity = Vector2(arrow_speed, 0)
