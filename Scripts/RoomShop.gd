extends "res://Scripts/BasicShop.gd"

func _on_BowsKnowledge_bought():
	elf.arrow_damage *= 1.2

func _on_Agility_bought():
	elf.dodge_chance += 0.01

func _on_Vitality_bought():
	elf.increase_max_hp(1)

func _on_Charizma_bought():
	pass # Replace with function body.
