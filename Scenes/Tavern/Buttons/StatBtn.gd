extends "res://Scenes/Tavern/Buttons/TavernBtn.gd"

export(String) var stat_name
export(float) var add_to_stat = 0.0
export(float) var multiply_stat = 1.0

func _on_BuyBtn_pressed():
	var v = elf_stats.get_stat_unchanged_value(stat_name)
	v = v*multiply_stat + add_to_stat
	elf_stats.get_stat(stat_name).value = stepify(v,0.01)
	
	._on_BuyBtn_pressed()