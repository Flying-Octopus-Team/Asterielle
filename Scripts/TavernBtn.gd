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

onready var game_data = get_tree().get_current_scene().find_node("GameData")

var elf_stats = load("res://Resources/ElfStats.tres")

func _ready():
	$Name.text = item_name
	update_price_label()

func _on_BuyBtn_pressed():
	match price_type:
		PriceType.GOLD:
			game_data.add_gold(-price)
		PriceType.XP:
			game_data.add_xp(-price)
	
	set_price(price * price_mod)
	
	emit_signal("bought")

func set_price(new_price:float):
	price = new_price
	update_price_label()

func update_price_label():
	$Price.text = str(price)
	