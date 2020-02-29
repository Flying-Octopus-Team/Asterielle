extends Node2D

func _ready():
	var world_animation = get_parent().get_node("WorldAnimation")
	world_animation.play("DayCycle")
