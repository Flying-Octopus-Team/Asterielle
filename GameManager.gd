extends Node


func stop_gameplay():
	get_parent().find_node("DwarvesSpawner").spawn = false
	pass
	
func resume_gameplay():
	get_parent().find_node("DwarvesSpawner").spawn = true
	get_parent().find_node("DwarvesSpawner").spawn_dwarf()
	pass