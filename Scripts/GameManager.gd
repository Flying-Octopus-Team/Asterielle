extends Node

onready var dwarves_spawner = get_parent().find_node("DwarvesSpawner")

func stop_gameplay():
	dwarves_spawner.spawn = false
	#TODO: zabić wszystkie boty 
	#var dwarf = find_node("Dwarf")
	#dwarf.death()

func resume_gameplay():
	dwarves_spawner.spawn = true
	dwarves_spawner.spawn_dwarf()