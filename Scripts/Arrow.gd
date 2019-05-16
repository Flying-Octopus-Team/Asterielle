extends KinematicBody2D

var velocity

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	