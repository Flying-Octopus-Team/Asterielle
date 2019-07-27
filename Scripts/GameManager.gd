extends Node

onready var dwarves_spawner = get_parent().find_node("DwarvesSpawner")

var Popup = load("res://Scenes/InformationPopup/Popup.tscn")

func stop_gameplay():
	dwarves_spawner.spawn = false
	#TODO: zabić wszystkie boty 
	#var dwarf = find_node("Dwarf")
	#dwarf.death()

func resume_gameplay():
	dwarves_spawner.spawn = true
	dwarves_spawner.spawn_dwarf()
	
func create_popup(title:String):
	var popup = Popup.instance()
	#get_parent().get_node("PopupsContainer").call_deferred("add_child", popup)
	#popup.call_deferred("init", title)
	return popup
	