extends SpawnerSystem

var Devil = load("res://Objects/ComingObjects/Devil/Devil.tscn")

onready var world = get_node("/root/World")

func spawn_devil():
	var devil = create_object(Devil, world)

	var cam_pos = get_node("/root/World").find_node("Camera2D").position
	devil.position.x = cam_pos.x + get_viewport_rect().size.x
	devil.position.y = 280
