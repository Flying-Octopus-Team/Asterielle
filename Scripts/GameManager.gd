extends Node

onready var dwarves_manager = get_parent().find_node("DwarvesManager")

var Popup = load("res://Scenes/InformationPopup/Popup.tscn")

func stop_gameplay():
	dwarves_manager.spawn = false
	#TODO: zabić wszystkie boty 
	#var dwarf = find_node("Dwarf")
	#dwarf.death()

func resume_gameplay():
	dwarves_manager.spawn = true
	dwarves_manager.spawn_dwarf()
	
func create_popup(title:String, parent:Node):
	var popup = Popup.instance()
	parent.call_deferred("add_child", popup)
	popup.call_deferred("init", title)
	return popup
	