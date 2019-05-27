extends KinematicBody2D

export(float) var damping

var gravity
var velocity : Vector2

var damage

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x *= damping
	
	rotation = atan2(velocity.y, velocity.x)
	
	move_and_slide(velocity)
	