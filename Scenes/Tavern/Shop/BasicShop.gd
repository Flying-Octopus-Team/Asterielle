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
	