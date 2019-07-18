extends Node


func stop_gameplay():
	get_parent().find_node("DwarvesSpawner").spawn = false
	#TODO: Usunąć wszystkie boty który są w tym momencie zrespione
	pass
	
func resume_gameplay():
	get_parent().find_node("DwarvesSpawner").spawn = true
	get_parent().find_node("DwarvesSpawner").spawn_dwarf()
	pass