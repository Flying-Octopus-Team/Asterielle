extends "res://Scenes/Tavern/Buttons/TavernBtn.gd"

func update_enabled() -> void:
	set_enabled(should_be_enabled())
	
func should_be_enabled() -> bool:
	var elf = get_node("/root/World").find_node("Elf")
	
	var max_hp: int = elf_stats.get_stat_value("vitality")
	return elf.hp < max_hp and price_gold <= game_data.gold