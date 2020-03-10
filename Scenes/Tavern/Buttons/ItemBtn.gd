extends TavernBtn

export(Resource) var item

func _on_BuyBtn_pressed():
	ElfStats.add_item(item.duplicate())
	._on_BuyBtn_pressed()
	generate_random()
	
func generate_random():
	item.generate_random()
	set_price_gold(item.price * GameData.tradesman_item_price_multipler)
	generate_popup_title()
	
func generate_popup_title():
	popup_title = ""
	
	for c in item.stat_changers:
		var stat = ElfStats.get_stat(c.stat_name)
		var stat_value = stat.get_value()
		var new_stat_value : float
		
		if stat.is_changed_by_item(item.name):
			new_stat_value = stat.get_value_replaced_item(item)
		else:
			new_stat_value = c.get_changed_value(stat_value)
			new_stat_value = stat.get_changed_value_with_changer(c)
		
		popup_title += c.stat_name + ": " + str(stepify(stat_value,0.01)) + " -> " + str(stepify(new_stat_value,0.01)) + "\n"
	
	popup_title = popup_title.trim_suffix("\n")
	
	if popup:
		popup.set_title(popup_title)
	
