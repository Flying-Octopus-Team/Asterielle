extends Control

var opened : bool = false

onready var root_node = get_tree().get_current_scene()
onready var game_data = root_node.find_node("GameData")
onready var elf = root_node.find_node("Elf")

func _ready():
	game_data.connect("gold_changed", self, "on_Gold_changed")
	pass
	
func on_Gold_changed():
	var items_list = find_node("Items")
	
	for i in range(items_list.get_child_count()):
		var item = items_list.get_child(i)	
		var price = float(item.get_node("Price").text)
		item.find_node("*BuyBtn").set_disabled(price > game_data.gold)

func _on_ShopOpenCloseBtn_pressed():
	var screen_width = get_viewport_rect().size.x
	if opened:
		rect_position.x = screen_width
		opened = false
	else:
		rect_position.x = screen_width - $ShopPanel.rect_size.x
		opened = true

func _on_ArrowDmgItem_bought():
	elf.arrow_damage *= 1.2
	elf.arrow_damage = round(elf.arrow_damage * 100) * 0.01
