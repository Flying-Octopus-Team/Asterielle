extends TextureButton

signal used

export(float) var strength

onready var elf = get_node("/root/World").find_node("Elf")
onready var amount_label = $AmountLabel

var amount : int = 0

func _ready():
	add_to_group("IHaveSthToSave")
	update_amount_label()
	connect("used", self, "_on_potion_used")

func _on_Potion_pressed():
	if amount > 0:
		add_potion(-1)
		emit_signal("used")
	
func add_potion(num:int=1):
	amount += num
	update_amount_label()

func update_amount_label():
	amount_label.text = str(amount)
	
func _on_potion_used():
	pass
	
func save():
	var save_dict = {
			_helth_potion = {
				_amount = amount
			}
	}
	return save_dict

func set_amount(potion_amount):
	amount = potion_amount
	update_amount_label()