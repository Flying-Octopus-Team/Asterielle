extends SpawnerSystem

var Devil = load("res://Objects/ComingObjects/Devil/Devil.tscn")

onready var world = get_node("/root/World")

func spawn_devil():
	var devil = create_object(Devil, world)
	devil.global_position = global_position