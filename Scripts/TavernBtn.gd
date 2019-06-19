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

func _ready():
	$Name.text = item_name
	update_price_label()

func _on_BuyBtn_pressed():
	match price_type:
		PriceType.GOLD:
			game_data.add_gold(-price)
		PriceType.XP:
			game_data.add_xp(-price)
	
	price *= price_mod
	update_price_label()
	
	emit_signal("bought")

func update_price_label():
	$Price.text = str(price)
	