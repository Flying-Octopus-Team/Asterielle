extends HBoxContainer

class_name TavernBtn

signal bought

export(String) var item_name
export(float) var price_gold
export(float) var price_gold_mod = 1.0
export(String) var popup_title
export(bool) var should_save_price = false

onready var default_price_gold : float = price_gold

onready var publican = get_node("/root/World").find_node("Publican")
var popup = null

func _ready():
	$Name.text = item_name
	update_price_label()

func _on_BuyBtn_pressed():
	if price_gold:
		GameData.add_gold(-price_gold)
		set_price_gold(price_gold * price_gold_mod)
		publican.on_spend_gold(price_gold)
	emit_signal("bought")

func set_price_gold(new_price:float):
	price_gold = new_price
	update_price_label()
	
func update_price_label():
	if price_gold:
		$PriceGold.text = str(stepify(price_gold,0.01)) + " zl"
	else:
		$PriceGold.text = ""
		
func set_enabled(enabled:bool) -> void:
	$BuyBtn.set_disabled(!enabled)
	
func update_enabled() -> void:
	var gold = GameData.gold
	
	var should_be_enabled = true
	
	if price_gold:
		should_be_enabled = gold >= price_gold
	
	set_enabled(should_be_enabled)

func create_popup():
	var game_manager = get_node("/root/World").find_node("GameManager")
	var screen = get_node("/root/World").find_node("TavernScreen")
	popup = game_manager.create_popup(popup_title, screen)

func reset_to_default() -> void:
	set_price_gold(default_price_gold)
	
func save() -> Dictionary:
	var save_dict = {
		_price_gold = price_gold,
	}
	
	return save_dict
	
func load_data(data) -> void:
	set_price_gold(data["_price_gold"])


func _on_BuyBtn_mouse_entered():
	if popup_title != "":
		create_popup()


func _on_BuyBtn_mouse_exited():
	if popup:
		popup.queue_free()
		popup = null
