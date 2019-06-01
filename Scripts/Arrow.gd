extends Area2D

export(float) var damping

var velocity : Vector2

var damage : float

var Dwarf = load("res://Scripts/Dwarf.gd")

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x *= damping
	
	rotation = atan2(velocity.y, velocity.x)
	
	position += velocity * delta

func _on_Arrow_area_entered(area):
	if area.name == "Ground":
		queue_free()