extends "res://Scripts/OneTavernScreen.gd"

onready var shop = find_node("Shop")

func on_enter():
	generate_random_items()
	.on_enter()

func generate_random_items():
	for btn in shop.get_children():
		btn.item.generate_random()
	