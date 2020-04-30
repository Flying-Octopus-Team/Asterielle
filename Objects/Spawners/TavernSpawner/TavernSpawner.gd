extends SpawnerSystem

var Tavern = load("res://Objects/ComingObjects/Tavern/Tavern.tscn")

onready var world = get_node("/root/World")

func spawn_tavern():
	var tavern = create_object(Tavern, world)
	var cam_pos = get_node("/root/World").find_node("Camera2D").position
	tavern.position.x = cam_pos.x + get_viewport_rect().size.x
	tavern.position.y = TRACK_HEIGHT
