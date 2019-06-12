extends "res://Scripts/BasicShop.gd"

func _on_BowsKnowledge_bought():
	elf.arrow_damage *= 1.2

func _on_Agility_bought():
	elf.dodge_chance += 0.01
