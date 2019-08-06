extends "res://Scenes/Tavern/Buttons/TavernBtn.gd"

export(Resource) var item

func _on_BuyBtn_pressed():
	elf_stats.add_item(item.duplicate())
	._on_BuyBtn_pressed()
	generate_random()
	
func generate_random():
	item.generate_random(elf_stats.get_stat_value("lucky"))
	print(game_data.tradesman_item_price_multipler)
	set_price(item.price * game_data.tradesman_item_price_multipler)
	generate_popup_title()
	
func generate_popup_title():
	popup_title = ""
	
	for c in item.stat_changers:
		var stat = elf_stats.get_stat(c.stat_name)
		var stat_value = stat.value
		var new_stat_value : float
		
		if stat.is_changed_by_item(item.name):
			new_stat_value = stat.get_value_replaced_item(item)
		else:
			new_stat_value = c.get_changed_value(stat_value)
		
		popup_title += c.stat_name + ": " + str(stat_value) + " -> " + str(new_stat_value) + "\n"
	
	popup_title = popup_title.trim_suffix("\n")
	
	if popup:
		popup.set_title(popup_title)
	