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
export(String) var popup_title 

onready var game_data = get_tree().get_current_scene().find_node("GameData")

onready var elf_stats = get_node("/root/World/ElfStats")

var popup = null

func _ready():
	elf_stats.get_stat("charisma").connect("value_changed", self, "_on_Charisma_value_changed")
	$Name.text = item_name
	update_price_label()

func _on_BuyBtn_pressed():
	match price_type:
		PriceType.GOLD:
			game_data.add_gold(-get_lower_price())
		PriceType.XP:
			game_data.add_xp(-get_lower_price())
	
	set_price(price * price_mod)
	
	emit_signal("bought")

func set_price(new_price:float):
	price = new_price
	update_price_label()

func _on_Charisma_value_changed(charisma_stat) -> void:
	update_price_label()

func get_lower_price() -> float:
	if price_type == PriceType.XP:
		return price
		
	return max(max(price - elf_stats.get_stat_value("charisma"), price * 0.5), 0)

func update_price_label():
	$Price.text = str(get_lower_price())
	
func set_enabled(enabled:bool) -> void:
	$BuyBtn.set_disabled(!enabled)
	
func _on_TavernBtn_mouse_entered():
	if popup_title != "":
		create_popup()
	
func _on_TavernBtn_mouse_exited():
	if popup:
		popup.queue_free()
		popup = null

func create_popup():
	var game_manager = get_node("/root/World").find_node("GameManager")
	popup = game_manager.create_popup(popup_title)
	var screen = get_node("/root/World").find_node("TavernScreen")
	screen.call_deferred("add_child", popup)
	popup.call_deferred("init", popup_title)


