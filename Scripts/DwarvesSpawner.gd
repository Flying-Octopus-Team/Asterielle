extends Node2D

var Dwarf = load("res://Scenes/Dwarf.tscn")

var current_dwarf_max_hp : float = 10.0

func _on_FirstDwarfTimer_timeout():
	spawn_dwarf()
	
func on_Dwarf_died():
	spawn_dwarf()
	
func spawn_dwarf():
	var dwarf = Dwarf.instance()
	get_parent().add_child(dwarf)
	dwarf.global_position = global_position
	
	dwarf.set_max_hp(current_dwarf_max_hp)
	
	var level_manager = get_parent().get_node("LevelManager")
	dwarf.connect("died", self, "on_Dwarf_died")
	dwarf.connect("died", level_manager, "on_Dwarf_died")
	
func on_next_level(current_level):
	print("Current level " + str(current_level))
	current_dwarf_max_hp += current_dwarf_max_hp * current_level * 0.1