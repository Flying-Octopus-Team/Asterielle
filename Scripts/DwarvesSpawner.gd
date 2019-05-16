extends Node2D

var Dwarf = load("res://Scenes/Dwarf.tscn")

func _on_FirstDwarfTimer_timeout():
	spawn_dwarf()
	
func _on_Dwarf_died():
	spawn_dwarf()
	
func spawn_dwarf():
	var dwarf = Dwarf.instance()
	get_parent().add_child(dwarf)
	dwarf.global_position = global_position
	dwarf.connect("died", self, "_on_Dwarf_died")
	
	

