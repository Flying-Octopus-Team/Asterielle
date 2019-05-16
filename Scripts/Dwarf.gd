extends KinematicBody2D

export(float) var move_speed
export(float) var hp

var velocity : Vector2

func _ready():
	go_forward()
	
func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	
	# Because of collision layer and mask dwarf collided with arrow
	if collision:
		on_collision_hit(collision)
	
func on_collision_hit(collision):
	collision.collider.queue_free()
	
	hp -= 1
	if hp <= 0:
		queue_free()
	
func _on_DwarfSpace_area_entered(area):
	velocity = Vector2.ZERO

func _on_DwarfSpace_area_exited(area):
	go_forward()

func go_forward():
	velocity = Vector2(-move_speed, 0)
	