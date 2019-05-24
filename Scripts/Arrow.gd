extends KinematicBody2D

var velocity
export(float) var force
export(float) var gravity

func _physics_process(delta):
	velocity.y += gravity * delta
	var collision = move_and_collide(velocity * delta)
	