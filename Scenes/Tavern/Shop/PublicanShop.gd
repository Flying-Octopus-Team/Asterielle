extends "res://Scenes/Tavern/Shop/BasicShop.gd"

onready var potions_container = get_node("/root/World").find_node("PotionsContainer")

func _on_VinenBtn_bought():
	elf.set_current_hp(elf_stats.get_stat_value("vitality"))

func _on_HealthPotionBtn_bought():
	potions_container.get_node("HealthPotion").add_potion()