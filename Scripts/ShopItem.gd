extends HBoxContainer

signal bought

enum PriceType {
	GOLD,
	XP
}

export(String) var item_name
export(float) var price
export(float) var price_mod = 1.0
export(PriceType) var price_type
export(String) var stat_name
export(float) var add_to_stat = 0.0
export(float) var multiply_stat = 1.0

onready var game_data = get_tree().get_current_scene().find_node("GameData")
onready var elf_stats = load("res://Resources/ElfStats.tres")

func _ready():
	$Name.text = item_name
	update_price_label()

func _on_BuyBtn_pressed():
	match price_type:
		PriceType.GOLD:
			game_data.add_gold(-price)
		PriceType.XP:
			game_data.add_xp(-price)
	
	elf_stats.get_stat(stat_name).value *= multiply_stat
	elf_stats.get_stat(stat_name).value += add_to_stat
	price *= price_mod
	update_price_label()
	
	emit_signal("bought")

func update_price_label():
	$Price.text = str(price)
	