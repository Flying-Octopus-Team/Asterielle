extends "res://Scenes/Tavern/OneTavernScreen.gd"

onready var reset_items_timer = $ResetItemsTimer

onready var items_panel = $ItemsPanel

var needs_regenerate_items = true

func on_enter():
	items_panel.visible = false
	if needs_regenerate_items:
		reset_items_timer.start()
		needs_regenerate_items = false
		generate_random_items()
		
	.on_enter()
	
func _on_ResetItemsTimer_timeout():
	if not visible:
		needs_regenerate_items = true
	else:
		generate_random_items()

func generate_random_items():
	for btn in shop.get_children():
		btn.generate_random()
	shop.disable_valid_buttons()

func _on_HoverInventory_mouse_entered():
	items_panel.visible = true
	items_panel.init_item_table(ElfStats.get_items())


func _on_HoverInventory_mouse_exited():
	items_panel.visible = false
