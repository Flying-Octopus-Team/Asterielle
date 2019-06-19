extends "res://Scripts/TavernBtn.gd"

export(String) var stat_name
export(float) var add_to_stat = 0.0
export(float) var multiply_stat = 1.0

onready var elf_stats = load("res://Resources/ElfStats.tres")

func _on_BuyBtn_pressed():
	elf_stats.get_stat(stat_name).value *= multiply_stat
	elf_stats.get_stat(stat_name).value += add_to_stat
	
	._on_BuyBtn_pressed()
