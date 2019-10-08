extends Node2D

export(float) var start_rotation_speed = 0.03

func _process(delta):
	rotation += start_rotation_speed * delta