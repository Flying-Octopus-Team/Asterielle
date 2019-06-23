extends "res://Scenes/Tavern/Buttons/TavernBtn.gd"

export(Resource) var item

func _on_BuyBtn_pressed():
	elf_stats.add_item(item.duplicate())
	._on_BuyBtn_pressed()
	generate_random()
	
func generate_random():
	item.generate_random(elf_stats.get_stat_value("lucky"))
	set_price(item.price)