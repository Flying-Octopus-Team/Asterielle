extends Node2D

var Dwarf = load("res://Scenes/Dwarf.tscn")

func _on_NextDwarfTimer_timeout():
	var dwarf = Dwarf.instance()
	get_parent().add_child(dwarf)
	dwarf.global_position = global_position
