extends HBoxContainer

signal bought

export(String) var item_name
export(float) var price
export(float) var price_mod

onready var game_data = get_tree().get_current_scene().find_node("GameData")

func _ready():
	add_to_group('IHaveSthToSave')
	$Name.text = item_name
	update_price_label()

func _on_BuyBtn_pressed():
	var old_price = price
	price += price * price_mod
	price = round(price * 100) * 0.01
	update_price_label()
	game_data.add_gold(-old_price)
	emit_signal("bought")

func update_price_label():
	$Price.text = str(price)

func save():
	var save_dict = {
		_price = price
	}
	return save_dict