extends BasicShop

func _ready():
	for btn in get_children():
		btn.connect("bought", self, "_on_Item_bought")
	
func _on_Item_bought() -> void:
	for btn in get_children():
		btn.generate_popup_title()
