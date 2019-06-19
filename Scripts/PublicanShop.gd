extends "res://Scripts/BasicShop.gd"

func _on_VinenBtn_bought():
	elf.set_current_hp(elf_stats.get_stat_value("vitality"))
