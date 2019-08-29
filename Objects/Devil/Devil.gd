extends Area2D

export(float) var move_speed = 100

onready var revival = get_parent().find_node("Revival")

func _physics_process(delta):
	position.x -= move_speed * delta

func _on_Tavern_area_entered(area):
	# Because of collision masks area is Elf
	revival.revive()
	queue_free()