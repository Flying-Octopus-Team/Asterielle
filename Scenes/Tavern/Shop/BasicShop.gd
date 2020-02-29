extends Control

class_name BasicShop

var opened : bool = false

onready var root_node = get_tree().get_current_scene()
onready var elf = root_node.find_node("Elf")

func _ready():
	GameData.connect("gold_changed", self, "disable_valid_buttons")
	GameData.connect("xp_changed", self, "disable_valid_buttons")
	
	for btn in get_children():
		btn.connect("bought", self, "disable_valid_buttons")
	
func disable_valid_buttons():
	for item in get_children():
		item.update_enabled()
		
func reset_to_default() -> void:
	for item in get_children():
		item.reset_to_default()
	
func save() -> Dictionary:
	var save_dict := {
		shop = {}
	}
	
	for item in get_children():
		if item.should_save_price:
			save_dict["shop"][item.name] = item.save()
	
	return save_dict
	
func load_data(data) -> void:
	for key in data.keys():
		var btn = get_node(key)
		btn.load_data(data[key])
	
	
