extends Node2D

func _ready():
	var planet_animation: AnimationPlayer = get_parent()
	planet_animation.play("SunMovement")