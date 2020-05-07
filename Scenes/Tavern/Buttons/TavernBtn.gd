extends HBoxContainer

class_name TavernBtn

signal bought

export(String) var item_name
export(float) var price_gold
export(float) var price_xp
export(float) var price_gold_mod = 1.0
export(float) var price_xp_mod = 1.0
export(String) var popup_title
export(bool) var should_save_price = false

onready var default_price_gold : float = price_gold
onready var default_price_xp : float = price_xp

onready var publican = get_node("/root/World").find_node("Publican")
var popup = null

func _ready():
	ElfStats.get_stat("charisma").connect("value_changed", self, "_on_Charisma_value_changed")
	$Name.text = item_name
	update_price_label()

func _on_BuyBtn_pressed():
	if price_gold:
		GameData.add_gold(-get_lower_price_gold())
		set_price_gold(price_gold * price_gold_mod)
		publican.on_spend_gold(get_lower_price_gold())
	if price_xp:
		GameData.add_xp(-price_xp)
		set_price_xp(price_xp * price_xp_mod)
	emit_signal("bought")

func set_price_gold(new_price:float):
	price_gold = new_price
	update_price_label()
	
func set_price_xp(new_price:float):
	price_xp = new_price
	update_price_label()

func _on_Charisma_value_changed(charisma_stat) -> void:
	update_price_label()

func get_lower_price_gold() -> float:
	var charisma = ElfStats.get_stat_value("charisma")
	var half_price_gold = price_gold * 0.5
	return max(price_gold - charisma, half_price_gold)

func update_price_label():
	if price_gold:
		$PriceGold.text = str(stepify(get_lower_price_gold(),0.01)) + " zl"
	else:
		$PriceGold.text = ""
		
	if price_xp:
		$PriceXp.text = str(stepify(price_xp, 0.01)) + " xp"
	else:
		$PriceXp.text = ""
		
func set_enabled(enabled:bool) -> void:
	$BuyBtn.set_disabled(!enabled)
	
func update_enabled() -> void:
	var gold = GameData.gold
	var xp = GameData.xp
	
	var should_be_enabled = true
	
	if price_gold:
		should_be_enabled = gold > price_gold
	if price_xp:
		should_be_enabled = should_be_enabled && xp > price_xp
	
	set_enabled(should_be_enabled)
	
func _on_TavernBtn_mouse_entered():
	if popup_title != "":
		create_popup()
	
func _on_TavernBtn_mouse_exited():
	if popup:
		popup.queue_free()
		popup = null

func create_popup():
	var game_manager = get_node("/root/World").find_node("GameManager")
	var screen = get_node("/root/World").find_node("TavernScreen")
	popup = game_manager.create_popup(popup_title, screen)

func reset_to_default() -> void:
	set_price_gold(default_price_gold)
	set_price_xp(default_price_xp)
	
func save() -> Dictionary:
	var save_dict = {
		_price_gold = price_gold,
		_price_xp = price_xp
	}
	
	return save_dict
	
func load_data(data) -> void:
	set_price_gold(data["_price_gold"])
	set_price_xp(data["_price_xp"])
