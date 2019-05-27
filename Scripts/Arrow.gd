extends Area2D

export(float) var damping

var velocity : Vector2

var damage

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x *= damping
	
	rotation = atan2(velocity.y, velocity.x)
	
	position += velocity * delta
	
func _on_Arrow_body_entered(body):
	# because of collision mas we're shure that body is dwarf
	queue_free()
	body.on_arrow_hit(self)
