extends "res://Objects/Potions/Potion.gd"

func _on_potion_used():
	elf.add_hp(strength)
	if(amount <= 0):
		hide()
