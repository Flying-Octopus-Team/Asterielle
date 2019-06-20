extends "res://Scripts/TavernBtn.gd"

export(Resource) var item

func _on_BuyBtn_pressed():
	elf_stats.add_item(item)
	item.generate_random()
	._on_BuyBtn_pressed()
	
func generate_random():
	item.generate_random()
	set_price(item.price)