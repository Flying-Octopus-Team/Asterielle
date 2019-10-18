extends SpawnerSystem

var Tavern = load("res://Objects/ComingObjects/Tavern/Tavern.tscn")

onready var world = get_node("/root/World")

func spawn_tavern():
	var tavern = create_object(Tavern, world)
	tavern.global_position = global_position