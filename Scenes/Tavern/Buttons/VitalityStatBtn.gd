extends "res://Scenes/Tavern/Buttons/StatBtn.gd"

func _on_BuyBtn_pressed():
	var old_max_hp = elf_stats.get_stat_value("vitality")
	var elf = get_node("/root/World").find_node("Elf")
	
	._on_BuyBtn_pressed()
	
	if elf.hp == old_max_hp:
		elf.hp = elf_stats.get_stat_value("vitality")
	