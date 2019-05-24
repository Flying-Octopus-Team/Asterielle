extends KinematicBody2D

export(float) var gravity
export(float) var damage

var velocity : Vector2

func _physics_process(delta):
	velocity.y += gravity * delta
	var collision = move_and_collide(velocity * delta)
	