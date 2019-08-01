extends "res://Scenes/Tavern/OneTavernScreen.gd"

onready var vine_btn = find_node("VineBtn")
	
func on_enter():
	.on_enter()
	vine_btn.update_enabled()